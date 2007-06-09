require File.dirname(__FILE__) + '/test_helper.rb'

context "The Response classes " do
  
  setup do
    @response = EC2::Response.new
    @response.name = "foo"
    @response.number = '123'
  end
  
  specify "should be a class of type OpenStruct" do
    @response.kind_of?(OpenStruct).should.equal true
    @response.kind_of?(Enumerable).should.equal true
  end
  
  specify "should return its members" do
    @response.members.length.should.equal 2
    test_array = ["number", "name"].sort
    @response.members.sort.should.equal test_array
  end
  
  specify "should properly respond to its 'each' method" do
    answer = @response.each do |f| f ; end
    answer.name.should.equal "foo"
    answer.number.should.equal '123'
  end
  
  specify "should respond to the '[]' method" do
    @response[:name].should.equal "foo"
  end
  
  specify "should respond correctly to the '[]=' method and set a variable" do
    @response[:name].should.equal "foo"
    @response[:name]="bar"
    @response[:name].should.equal "bar"
  end
  
  specify "should respond correctly to the 'each_pair' method" do
    @struct = EC2::Response.new
    @struct.name = "foo"
    @struct.each_pair { |k,v| @key = k; @value = v }
    @key.should.equal "name"
    @value.should.equal "foo"
  end
  
  
end