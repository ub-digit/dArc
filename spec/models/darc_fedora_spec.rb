require 'rails_helper'

RSpec.describe DarcFedora, :type => :model do
	before :each do
		config_init
	end

	describe "find" do 
		context "of wrong type" do 
			it "returns a object" do 
				expect{DarcFedora.find(db_ids[:authority])}.to raise_error
			end 
		end
		context "with a non existing id" do 
			it "raises an error" do 
				expect{DarcFedora.find(db_ids[:invalid])}.to raise_error
			end 
		end
	end

	
end
