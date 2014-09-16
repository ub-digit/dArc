require 'rails_helper'

RSpec.describe DarcFedora, :type => :model do
	before :each do
		config_init
	end

	describe "find" do 
		context "of wrong type" do 
			it "returns a object" do 
				expect{DarcFedora.find(25)}.to raise_error
			end 
		end
		context "with a non existing id" do 
			it "raises an error" do 
				expect{DarcFedora.find(-7)}.to raise_error
			end 
		end
	end

end
