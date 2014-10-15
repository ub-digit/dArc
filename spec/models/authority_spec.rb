require 'rails_helper'

RSpec.describe Authority, :type => :model do

	describe "find" do 
		context "with an existing id" do 
			it "returns a object" do 
				result = Authority.find(RSpec.configuration.db_ids[:authority])
				expect(result).to_not be nil
			end 
		end
		context "with a non existing id" do 
			it "raises an error" do 
				expect{Authority.find(-2)}.to raise_error
			end 
		end
		context "with wrong object type" do
			it "raises an error" do
				expect{Authority.find(RSpec.configuration.db_ids[:archive])}.to raise_error
			end
		end
	end

	describe "class" do
		context "full_load" do
			it "should exist" do
				a = Authority.find(RSpec.configuration.db_ids[:authority])
				expect(a.respond_to?(:full_load)).to be true
			end
		end
	end

	describe "save" do
		context "with valid attributes" do
			it "should save without errors" do
				a = Authority.find(RSpec.configuration.db_ids[:authority], {:select => :update})
				a.from_json({"startdate" => "1337", "enddate" => "1408", "type" => "person", "forename" => "test", "surname" => "testsson"}.to_json)
				expect(a.save).to be true
			end
		end
		context "with invalid attributes" do
			it "should return false" do
				a = Authority.find(RSpec.configuration.db_ids[:authority], {:select => :update})
				a.from_json({"type" => "wrongtype"}.to_json)
				expect(a.save).to be false
			end
		end
	end
	describe "purge" do
		context "with existing archive relations" do
			it "should return false and not delete object" do
				expect(Authority.purge(RSpec.configuration.db_ids[:authority])).to be false
				a = Authority.find(RSpec.configuration.db_ids[:authority], {:select => :full})
				expect(a).to_not be nil
			end
		end
		context "without existing archive relations" do
			it "should return true and delete the object" do
				a = Authority.create()
				a.from_json({"title" => "temp title", "startdate" => "1337", "enddate" => "1408", "type" => "person", "forename" => "test", "surname" => "testsson"}.to_json)
				expect(a.save).to be true
				id = a.as_json[:id]
				expect(Authority.purge(id)).to be true
				b = Authority.find_by_id(id, {:select => :full})
				expect(b).to be nil
			end
		end
	end
end
