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

	describe "save" do
		context "with valid attributes" do
			it "should save without errors" do
				a = Archive.find(db_ids[:archive], {:select => :update})
				a.from_json({"unitid" => "1337", "unitdate" => "1337 - 1408", "unittitle" => "A vewy vewy quiet archive"}.to_json)
				expect(a.save).to be true
			end
		end
		# context "with invalid attributes" do
		# 	it "should return false" do
		# 		a = Archive.find(db_ids[:archive], {:select => :update})
		# 		a.from_json({"type" => "wrongtype"}.to_json)
		# 		expect(a.save).to be false
		# 	end
		# end
	end
end