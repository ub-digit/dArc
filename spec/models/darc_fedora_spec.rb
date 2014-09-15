require 'rails_helper'

RSpec.configure do |c|
	c.include TestHelper
end
   RSpec.describe DarcFedora, :type => :model do
	 before :each do
		config_init
	end

	# Find tests only work when connected to a fedora instance
	
	#describe "find" do 
	#	context "with an existing id" do 
	#		it "returns a object" do 
    #          result = DarcFedora.find(7)
    #          expect(result).to_not be nil
	#		end 
	#	end
	#	context "with a non existing id" do 
	#		it "returns a nil object" do 
    #          result = DarcFedora.find(-7)
    #          expect(result).to be nil
	#		end 
	#	end
	#end

	describe "initialize" do
		context "with a valid mock object" do
			it "returns an object" do
				obj = DarcFedora.new("testID", RubydoraMock.new)
				expect(obj).to_not be nil
			end
		end
	end
end