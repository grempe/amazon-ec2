module AWS

  class Response

    # Parse the XML response from AWS
    #
    # @option options [String] :xml The XML response from AWS that we want to parse
    # @option options [Hash] :parse_options Override the options for XmlSimple.
    # @return [Hash] the input :xml converted to a custom Ruby Hash by XmlSimple.
    def self.parse(options = {})
      options = {
        :xml => "",
        :parse_options => { 'forcearray' => ['item', 'member'], 'suppressempty' => nil, 'keeproot' => false }
      }.merge(options)
      response = XmlSimple.xml_in(options[:xml], options[:parse_options])
    end

  end  # class Response

end  # module AWS

