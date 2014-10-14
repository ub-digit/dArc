require 'rails_helper'

RSpec.describe Disk, :type => :model do

	describe "find" do 
		context "with an existing id" do 
			it "returns a object" do 
				result = Disk.find(RSpec.configuration.db_ids[:disk])
				expect(result).to_not be nil
			end
		end
		context "with a non existing id" do 
			it "raises an error" do 
				expect{Disk.find(-2)}.to raise_error
			end 
		end
	end

	describe "save" do
		context "with valid attributes" do
			it "should save without errors" do
				a = Disk.find(RSpec.configuration.db_ids[:disk], {:select => :update})
				a.from_json({"title" => "Test title 2"}.to_json)
				expect(a.save).to be true
			end
		end
		context "with an invalid title" do
			it "should return false" do
				a = Disk.find(RSpec.configuration.db_ids[:disk], {:select => :update})
				a.from_json({"title" => ""}.to_json)
				expect(a.save).to be false
				expect(a.errors.messages.size).to eq 1
			end
		end
		context "removing an archive" do
			it "should save without errors" do
				a = Disk.find(RSpec.configuration.db_ids[:disk], {:select => :update})
				params = {"title" => "Test title 3", "archives" => []}.to_json
				a.from_json(params)
				a.save

				# Check for updated relation through loop to allow for index to synchronize
				json = nil
				wait_for_relation(20.seconds) do
					b = Disk.find(RSpec.configuration.db_ids[:disk], {:select => :full})
					json = JSON.parse(b.to_json)
					json["archives"].size < 1 
				end
				expect(json["archives"].size).to eq 0
			end
		end

		context "adding an archive" do
			it "should save without errors" do
				a = Disk.find(RSpec.configuration.db_ids[:disk], {:select => :update})
				params = {"title" => "Test title 3", "archives" => [RSpec.configuration.db_ids[:archive]]}.to_json
				a.from_json(params)
				a.save

				# Check for updated relation through loop to allow for index to synchronize
				json = nil
				wait_for_relation(20.seconds) do
					b = Disk.find(RSpec.configuration.db_ids[:disk], {:select => :full})
					json = JSON.parse(b.to_json)
					json["archives"].size > 0 
				end
				expect(json["archives"].size).to eq 1
			end
		end
	end
end