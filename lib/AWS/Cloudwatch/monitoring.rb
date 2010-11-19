module AWS
  module Cloudwatch
    class Base < AWS::Base

      # This method call lists available Cloudwatch metrics attached to your EC2
      # account. To get further information from the metrics, you'll then need to
      # call get_metric_statistics.
      #
      # there are no options available to this method.

      def list_metrics
        raise ArgumentError, "Server must be monitoring.amazonaws.com" if server != 'monitoring.amazonaws.com'
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
        raise ArgumentError, "Server must be monitoring.amazonaws.com" if server != 'monitoring.amazonaws.com'
        raise ArgumentError, ":start_time must be before :end_time" if options[:start_time] > options[:end_time]
        raise ArgumentError, ":measure_name must be provided" if options[:measure_name].nil? || options[:measure_name].empty?
        raise ArgumentError, ":statistics must be provided" if options[:statistics].nil? || options[:statistics].empty?

        stats = {}
        if options[:statistics].is_a? Array
          options[:statistics].each_with_index{ |s, i|
            stats['Statistics.member.' + (i + 1).to_s] = s
          }
        else
          stats['Statistics.member.1'] = options[:statistics]
        end

        dims = {}
        if options[:dimensions]
          options[:dimensions].each_with_index{ |values, i|
            dims["Dimensions.member.#{i + 1}.Name"] = values[0]
            dims["Dimensions.member.#{i + 1}.Value"] = values[1]
          }
        end

        params = {
                    "CustomUnit" => options[:custom_unit],
                    "EndTime" => options[:end_time].iso8601,
                    "MeasureName" => options[:measure_name],
                    "Namespace" => options[:namespace],
                    "Period" => options[:period].to_s,
                    "StartTime" => options[:start_time].iso8601,
                    "Unit" => options[:unit]
        }.merge(stats).merge(dims)

        return response_generator(:action => 'GetMetricStatistics', :params => params)

      end

    end

  end

end

