module AWS
  module Cloudwatch
    class Base < AWS::Base

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

      # This method pushes custom metrics to AWS. See http://docs.amazonwebservices.com/AmazonCloudWatch/latest/APIReference/API_PutMetricData.html 
      #
      # @option options [String] :namespace (nil) The namepsace of the metric you want to put data into. Cannot begin with 'AWS/'.
      # @option options [String] :metric_name (nil) The name of the metric. No explicit creation is required, but it may take up to 15 minutes to show up.
      # @option options [String] :unit ('None') One of the units that Amazon supports. See http://docs.amazonwebservices.com/AmazonCloudWatch/latest/APIReference/API_MetricDatum.html
      # @option options [Double] :value (nil) The value of the metric. Very large (10 ** 126) and very small (10 ** -130) will be truncated.
      # @option options [optional, Hash] :dimensions ({}) Hash like {'Dimension1' => 'value1', 'Dimension2' => 'value2', ...} that describe the dimensions.
      # @option options [Time] :timestamp (Time.now) The timestamp that the point(s) will be recorded fora.
      # @option options [Array] :metric_data ([{}]) An array of hashes for the data points that will be sent to CloudWatch. All previous options except :namespace can be specified and will override options specified outside the element. Can only be 20 items long.
      # @example
      #   # Put a single point measured now
      #   cw.put_metric_data({
      #     :namespace => 'Foo',
      #     :metric_name => 'Clicks',
      #     :unit => 'Count',
      #     :value => 5
      #   })
      # @example
      #   # Put one point for each of the last five minutes with one call
      #   points = (0..5).map do |min|
      #     {:timestamp => Time.now - min * 60, :value = rand()}
      #   end
      #
      #   cw.put_metric_data({
      #     :namespace => 'Foo'
      #     :metric_name => 'Clicks',
      #     :unit => 'Count',
      #     :metric_data => points,
      #     :dimensions => {'InstanceID' => 'i-af23c4b9',
      #                     'InstanceType' => 'm2.4xlarge'}
      #   })
      #     
      def put_metric_data( options={} )
        options = {
          :timestamp => Time.now,
          :metric_data => [{}],
          :dimensions => {},
          :unit => 'None'
        }.merge options
        namespace = options.delete :namespace
        metric_data = options.delete :metric_data
        metric_data = [{}] unless metric_data.any?
        merged_data = metric_data.map do |datum|
          options.merge datum
        end

        params = {
          "Namespace" => namespace
        }
        raise ArgumentError, ":namespace cannot be blank" if namespace.nil?
        
        merged_data.each_with_index do |datum, idx|
          prefix = "MetricData.member.#{idx+1}."
          raise ArgumentError, ":metric_name cannot be blank" if datum[:metric_name].nil?
          raise ArgumentError, ":unit cannot be blank" if datum[:unit].nil?
          raise ArgumentError, ":value cannot be blank" if datum[:value].nil?
          raise ArgumentError, ":timestamp cannot be blank" if datum[:timestamp].nil?

          datum_params = {
            prefix + "MetricName" => datum[:metric_name],
            prefix + "Unit" => datum[:unit],
            prefix + "Value" => datum[:value].to_s,
            prefix + "Timestamp" => datum[:timestamp].iso8601
          }
          ii = 1
          datum[:dimensions].each_pair do |dimension, value|
            dimension_prefix = prefix + "Dimensions.member.#{ii}."
            raise ArgumentError, "value cannot be blank for a dimension" if value.nil?
            datum_params.merge!({
              dimension_prefix + "Name" => dimension,
              dimension_prefix + "Value" => value
            })
            ii += 1
          end unless datum[:dimensions].nil?

          params.merge! datum_params
        end

        return response_generator(:action => 'PutMetricData', :params => params)
      end

    end

  end

end

