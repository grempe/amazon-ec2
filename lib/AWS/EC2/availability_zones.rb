module AWS
  module EC2
    class Base < AWS::Base

      # describe_availability_zones filters list
      DESCRIBE_AVAILABILITY_ZONES_FILTERS = [
        :message,
        :region_name,
        :state,
        :zone_name
      ]

      # describe_availability_zones alternative filter names
      DESCRIBE_AVAILABILITY_ZONES_FILTER_ALTERNATIVES = { :zone_name_filter => :zone_name, }

      # describe_regions filter list
      DESCRIBE_REGIONS_FILTERS = [:endpoint, :region_name]

      # describe_regions alternative filter names
      DESCRIBE_REGIONS_FILTER_ALTERNAITVES = { :region_name_filter => :region_name, }


      # The DescribeAvailabilityZones operation describes availability zones that are currently
      # available to the account and their states.
      #
      # An optional list of zone names can be passed.
      #
      # @option options [optional, String] :zone_name ([]) an Array of zone names
      #
      def describe_availability_zones( options = {} )
        options = { :zone_name => [] }.merge(options)
        params = pathlist("ZoneName", options.delete(:zone_name))

        DESCRIBE_AVAILABILITY_ZONES_FILTER_ALTERNATIVES.each do |alternative_key, original_key|
          next unless options.include?(alternative_key)
          options[original_key] = options.delete(alternative_key)
        end

        invalid_filters = options.keys - DESCRIBE_AVAILABILITY_ZONES_FILTERS
        raise ArgumentError, "invalid filter(s): #{invalid_filters.join(', ')}" if invalid_filters.any?
        params.merge!(filterlist(options))
        return response_generator(:action => "DescribeAvailabilityZones", :params => params)
      end

      # The DescribeRegions operation describes regions.
      #
      # An optional list of region names can be passed.
      #
      # @option options [optional, String] :region_name ([]) an Array of region names
      # @option options [optional, String] :endpoint ([]) an Array of endpoint
      # @option options [optional, String] :region_name_filter ([]) an Array of region names
      #
      def describe_regions( options = {} )
        options = { :zone_name => [] }.merge(options)
        params = pathlist("ZoneName", options.delete(:zone_name))

        DESCRIBE_REGIONS_FILTER_ALTERNAITVES.each do |alternative_key, original_key|
          next unless options.include?(alternative_key)
          options[original_key] = options.delete(alternative_key)
        end

        invalid_filters = options.keys - DESCRIBE_REGIONS_FILTERS
        raise ArgumentError, "invalid filter(s): #{invalid_filters.join(', ')}" if invalid_filters.any?
        params.merge!(filterlist(options))
        return response_generator(:action => "DescribeRegions", :params => params)
      end

    end
  end
end

