require 'rails_helper'

RSpec.describe Archive, :type => :model do

	describe "find" do 
		context "with an existing id" do 
			it "returns a object" do 
				result = Archive.find(RSpec.configuration.db_ids[:archive])
				expect(result).to_not be nil
			end 
		end
		context "with a non existing id" do 
			it "raises an error" do 
				expect{Archive.find(-2)}.to raise_error
			end 
		end
	end

	describe "save" do
		context "with valid attributes" do
			it "should save without errors" do
				a = Archive.find(RSpec.configuration.db_ids[:archive], {:select => :update})
				a.from_json({"unitid" => "1337", "unitdate" => "1337 - 1408", "unittitle" => "A vewy vewy quiet archive"}.to_json)
				expect(a.save).to be true
			end
		end
		context "with an invalid title" do
			it "should return false" do
				a = Archive.find(RSpec.configuration.db_ids[:archive], {:select => :update})
				a.from_json({"title" => ""}.to_json)
				expect(a.save).to be false
				expect(a.errors.messages.size).to eq 1
			end
		end
	end
end