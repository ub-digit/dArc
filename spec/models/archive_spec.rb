require 'rails_helper'

RSpec.describe Archive, :type => :model do
	before :each do
		config_init
	end

	describe "find" do 
		context "with an existing id" do 
			it "returns a object" do 
				result = Archive.find(db_ids[:archive])
				expect(result).to_not be nil
			end 
		end
		context "with a non existing id" do 
			it "raises an error" do 
				expect{Archive.find(db_ids[:invalid])}.to raise_error
			end 
		end
	end
end