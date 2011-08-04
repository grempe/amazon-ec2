module AWS
  module Cloudwatch
    class StatisticSet
      attr_accessor :maximum, :minimum, :sample_count, :sum

      def initialize(maximum, minimum, sample_count, sum)
        @maximum, @minimum, @sample_count, @sum = maximum, minimum, sample_count, sum
      end
    end

    class Metric
      Unit = [
        "Seconds", "Microseconds", "Milliseconds",
        "Bytes", "Kilobytes", "Megabytes", "Gigabytes", "Terabytes",
        "Bits", "Kilobits", "Megabits", "Gigabits", "Terabits",
        "Percent", "Count",
        "Bytes/Second", "Kilobytes/Second", "Megabytes/Second", "Gigabytes/Second", "Terabytes/Second",
        "Bits/Second", "Kilobits/Second", "Megabits/Second", "Gigabits/Second", "Terabits/Second", "Count/Second", "None"
      ]
        
      def initialize ( options ={} )
        @options = options.dup
        @options[:timestamp] ||= Time.new
        @options[:dimensions] ||= {}

        raise ArgumentError, 'name cannot be blank' if @options[:name].nil? or options[:name] =~ /^\s+$/
        raise ArgumentError, "unit must be one (#{Unit.inspect}; was #{@options[:unit].inspect})" if @options[:unit].nil? or !Unit.include?(@options[:unit])
        raise ArgumentError, "value must be a numeric value (was: #{@options[:value].inspect})" if !@options[:value].kind_of?(Numeric)
        raise ArgumentError, 'timestamp must be a Time object' if !@options[:timestamp].kind_of?(Time)
        raise ArgumentError, 'statistic_set must be a StatisticSet object' if @options[:statistic_set] and !@options[:statistic_set].kind_of?(StatisticSet)
      end
      
      def to_params(index=1)
        member = "MetricData.member.#{index}"
        params = {
          "#{member}.MetricName" => @options[:name],
          "#{member}.Unit" => @options[:unit],
          "#{member}.Value" => @options[:value].to_s,
          "#{member}.Timestamp" => @options[:timestamp].iso8601,
        }
        dimension = 1
        @options[:dimensions].each_pair do |name, value|
          params["#{member}.Dimensions.member.#{dimension}.Name"] = name
          params["#{member}.Dimensions.member.#{dimension}.Value"] = value
          dimension += 1
        end
        if @options[:statistic_set]
          params["#{member}.StatisticSet.Maximum"] = @options[:statistic_set].maximum.to_s
          params["#{member}.StatisticSet.Minimum"] = @options[:statistic_set].minimum.to_s
          params["#{member}.StatisticSet.SampleCount"] = @options[:statistic_set].sample_count.to_s
          params["#{member}.StatisticSet.Sum"] = @options[:statistic_set].sum.to_s
        end
        
        params
      end
    end
    
    class Base < AWS::Base

      # This method call puts a custom metric datapoint into CloudWatch. It takes a namespace and an
      # array of Metric objects that can define multiple dimensions as well
      def put_metric_data(namespace, metrics)
        metrics = [metrics] if !metrics.kind_of?(Array)
        raise ArgumentError, "namespace must be provided" if namespace.nil? or namespace =~ /^\s+$/
        raise ArgumentError, "namespace cannot begin with AWS/" if namespace =~ /^AWS\//
        raise ArgumentError, "metrics must be an array of Metric AWS::Cloudwatch::Metric objects" if metrics.inject(false) { |acc, obj| acc || !obj.kind_of?(Metric) }

        params = {
          "Namespace" => namespace,
        }
        metrics.each do |metric|
          params.merge!(metric.to_params)
        end

        return response_generator(:action => 'PutMetricData', :params => params)
      end
      
      # This method call lists available Cloudwatch metrics attached to your EC2
      # account. To get further information from the metrics, you'll then need to
      # call get_metric_statistics.
      #
      # there are no options available to this method.
      def list_metrics
        return response_generator(:action => 'ListMetrics', :params => {})
      end

      # get_metric_statistics pulls a hashed array from Cloudwatch with the stats
      # of your requested metric.
      # Once you get the data out, if you assign the results into an object like:
      # res = @mon.get_metric_statistics(:measure_name => 'RequestCount', \
      #     :statistics => 'Average', :namespace => 'AWS/ELB')
      #
      # This call gets the average request count against your ELB at each sampling period
      # for the last 24 hours. You can then attach a block to the following iterator
      # to do whatever you need to:
      # res['GetMetricStatisticsResult']['Datapoints']['member'].each
      #
      # @option options [String] :custom_unit (nil) not currently available, placeholder
      # @option options [String] :dimensions (nil) Option to filter your data on. Check the developer guide
      # @option options [Time] :end_time (Time.now()) Outer bound of the date range you want to view
      # @option options [String] :measure_name (nil) The measure you want to check. Must correspond to
      # =>                                           provided options
      # @option options [String] :namespace ('AWS/EC2') The namespace of your measure_name. Currently, 'AWS/EC2' and 'AWS/ELB' are available
      # @option options [Integer] :period (60) Granularity in seconds of the returned datapoints. Multiples of 60 only
      # @option options [String] :statistics (nil) The statistics to be returned for your metric. See the developer guide for valid options. Required.
      # @option options [Time] :start_time (Time.now() - 86400) Inner bound of the date range you want to view. Defaults to 24 hours ago
      # @option options [String] :unit (nil) Standard unit for a given Measure. See the developer guide for valid options.
      def get_metric_statistics ( options ={} )
        options = { :custom_unit => nil,
                    :dimensions => nil,
                    :end_time => Time.now(),      #req
                    :measure_name => "",          #req
                    :namespace => "AWS/EC2",
                    :period => 60,
                    :statistics => "",            # req
                    :start_time => (Time.now() - 86400), # Default to yesterday
                    :unit => "" }.merge(options)

        raise ArgumentError, ":end_time must be provided" if options[:end_time].nil?
        raise ArgumentError, ":end_time must be a Time object" if options[:end_time].class != Time
        raise ArgumentError, ":start_time must be provided" if options[:start_time].nil?
        raise ArgumentError, ":start_time must be a Time object" if options[:start_time].class != Time
        raise ArgumentError, ":start_time must be before :end_time" if options[:start_time] > options[:end_time]
        raise ArgumentError, ":measure_name must be provided" if options[:measure_name].nil? || options[:measure_name].empty?
        raise ArgumentError, ":statistics must be provided" if options[:statistics].nil? || options[:statistics].empty?

        params = {
                    "CustomUnit" => options[:custom_unit],
                    "EndTime" => options[:end_time].iso8601,
                    "MeasureName" => options[:measure_name],
                    "Namespace" => options[:namespace],
                    "Period" => options[:period].to_s,
                    "StartTime" => options[:start_time].iso8601,
                    "Unit" => options[:unit]
        }

        # FDT: Fix statistics and dimensions values
        if !(options[:statistics].nil? || options[:statistics].empty?)
          stats_params = {}
          i = 1
          options[:statistics].split(',').each{ |stat|
            stats_params.merge!( "Statistics.member.#{i}" => "#{stat}" )
            i += 1
          }
          params.merge!( stats_params )
        end

        if !(options[:dimensions].nil? || options[:dimensions].empty?)
          dims_params = {}
          i = 1
          options[:dimensions].split(',').each{ |dimension|
            dimension_var = dimension.split('=')
            dims_params = dims_params.merge!( "Dimensions.member.#{i}.Name" => "#{dimension_var[0]}", "Dimensions.member.#{i}.Value" => "#{dimension_var[1]}" )
            i += 1
          }
          params.merge!( dims_params )
        end

        return response_generator(:action => 'GetMetricStatistics', :params => params)

      end

    end

  end

end

