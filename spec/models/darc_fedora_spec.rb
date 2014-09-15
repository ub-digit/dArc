require 'rails_helper'
require 'vcr'

# VCR.configure do |c|
# 	c.cassette_library_dir = 'spec/fixtures/vcr_cassettes/darc_fedora/'
# 	c.hook_into :webmock # or :fakeweb
# end

RSpec.describe DarcFedora, :type => :model do
	before :each do
		config_init
	end

	describe "find" do 
		context "with an existing id" do 
			it "returns a object" do 
				result = DarcFedora.find(25)
				expect(result).to_not be nil
			end 
		end
		context "with a non existing id" do 
			it "returns a nil object" do 
				result = DarcFedora.find(-7)
				expect(result).to be nil
				expect{DarcFedora.find(-7)}.to raise_error
			end 
		end
	end

	describe "initialize" do
		context "with a valid mock object" do
			it "returns an object" do
				obj = DarcFedora.new("testID", RubydoraMock.new)
				expect(obj).to_not be nil
			end
		end
	end
end
