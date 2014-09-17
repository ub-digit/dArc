require 'rails_helper'

RSpec.describe Authority, :type => :model do
	before :each do
		config_init
	end

	describe "find" do 
		context "with an existing id" do 
			it "returns a object" do 
				result = Authority.find(db_ids[:authority])
				expect(result).to_not be nil
			end 
		end
		context "with a non existing id" do 
			it "raises an error" do 
				expect{Authority.find(db_ids[:invalid])}.to raise_error
			end 
		end
		context "with wrong object type" do
			it "raises an error" do
				expect{Authority.find(db_ids[:disk])}.to raise_error
			end
		end
	end

	describe "class" do
		context "full_load" do
			it "should exist" do
				a = Authority.find(db_ids[:authority])
				expect(a.respond_to?(:full_load)).to be true
			end
		end
	end

	describe "save" do
		context "with valid attributes" do
			it "should save without errors" do
				a = Authority.find(db_ids[:authority], {:select => :update})
				a.from_json({"startdate" => "1337"}.to_json)
				expect(a.save).to be true
			end
		end
	end
end
