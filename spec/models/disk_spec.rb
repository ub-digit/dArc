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
	describe "create" do
		context "an empty object" do
			it "should return an empty object" do
				result = Disk.create()
				expect(result).to_not be nil
				result.delete
			end
		end
		context "with valid parameters" do
			it "should return a created object" do
				result = Disk.create()
				result.from_json({"title"=>nil, "item_unittitle"=>"asd", "item_unitdate"=>"ad", "item_unitid"=>"ad", "archives"=> [RSpec.configuration.db_ids[:archive2]]}.to_json)
				expect(result.save).to be true
				result.delete
			end
		end
	end
	describe "save" do
		context "with valid attributes" do
			it "should save without errors" do
				a = Disk.find(RSpec.configuration.db_ids[:disk], {:select => :update})
				params = {"item_unittitle" => a.as_json[:item_unittitle], "item_unitid" => "234", "archives" => a.as_json[:archives]}.to_json
				a.from_json(params)
				expect(a.save).to be true
			end
		end
		context "with an empty archives array" do
			it "should produce an error" do
				a = Disk.find(RSpec.configuration.db_ids[:disk], {:select => :update})
				params = {"title" => "Test title 3", "archives" => []}.to_json
				a.from_json(params)
				expect(a.save).to be false
				expect(a.errors.messages.size).to eq 1
			end
		end
		context "with an archives array with more than one entry" do
			it "should produce an error" do
				a = Disk.find(RSpec.configuration.db_ids[:disk], {:select => :update})
				params = {"title" => "Test title 3", "archives" => [RSpec.configuration.db_ids[:archive], RSpec.configuration.db_ids[:archive2]]}.to_json
				a.from_json(params)
				expect(a.save).to be false
				expect(a.errors.messages.size).to eq 1
			end
		end
		context "with a new archive" do
			it "should save without errors" do
				a = Disk.find(RSpec.configuration.db_ids[:disk], {:select => :update})
				params = {"title" => "Test title 3", "archives" => [RSpec.configuration.db_ids[:archive2]]}.to_json
				a.from_json(params)
				expect(a.save).to be true

				# Check for updated relation through loop to allow for index to synchronize
				json = nil
				wait_for_relation(20.seconds) do
					b = Disk.find(RSpec.configuration.db_ids[:disk], {:select => :full})
					json = b.as_json
					json[:archives].first != RSpec.configuration.db_ids[:archive] 
				end
				expect(json[:archives].first).to eq RSpec.configuration.db_ids[:archive2]
			end
		end
	end
	describe "purge" do
		context "with existing disk-image relations" do
			it "should return false and not delete object" do
				expect(Disk.purge(RSpec.configuration.db_ids[:disk])).to be false
				a = Disk.find(RSpec.configuration.db_ids[:disk], {:select => :full})
				expect(a).to_not be nil
			end
		end
		context "without existing disk-image relations" do
			it "should return true and delete the object" do
				a = Disk.create()
				a.from_json({"item_unittitle" => "Title", "item_unitid" => "DiskID", "archives" => [RSpec.configuration.db_ids[:archive]]}.to_json)
				expect(a.save).to be true
				id = a.as_json[:id]
				expect(Disk.purge(id)).to be true
				b = Disk.find_by_id(id, {:select => :full})
				expect(b).to be nil
			end
		end
	end
end