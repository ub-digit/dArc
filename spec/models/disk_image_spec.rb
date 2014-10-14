require 'rails_helper'

RSpec.describe DiskImage, :type => :model do

	describe "find" do 
		context "with an existing id" do 
			it "returns a object" do 
				result = DiskImage.find(RSpec.configuration.db_ids[:disk_image])
				expect(result).to_not be nil
			end
		end
		context "with a non existing id" do 
			it "raises an error" do 
				expect{DiskImage.find(-2)}.to raise_error
			end 
		end
	end

	describe "save" do
		context "with valid attributes" do
			it "should save without errors" do
				a = DiskImage.find(RSpec.configuration.db_ids[:disk_image], {:select => :update})
				a.from_json({"title" => "Test title 2"}.to_json)
				expect(a.save).to be true
			end
		end
		context "with an invalid title" do
			it "should return false" do
				a = DiskImage.find(RSpec.configuration.db_ids[:disk_image], {:select => :update})
				a.from_json({"title" => ""}.to_json)
				expect(a.save).to be false
				expect(a.errors.messages.size).to eq 1
			end
		end
		context "removing a disk" do
			it "should save without errors" do
				a = DiskImage.find(RSpec.configuration.db_ids[:disk_image], {:select => :update})
				params = {"title" => "Test title 3", "disks" => []}.to_json
				a.from_json(params)
				a.save

				# Check for updated relation through loop to allow for index to synchronize
				json = nil
				wait_for_relation(20.seconds) do
					b = DiskImage.find(RSpec.configuration.db_ids[:disk_image], {:select => :full})
					json = JSON.parse(b.to_json)
					json["disks"].size < 1 
				end
				expect(json["disks"].size).to eq 0
			end
		end

		context "adding a disk" do
			it "should save without errors" do
				a = DiskImage.find(RSpec.configuration.db_ids[:disk_image], {:select => :update})
				params = {"title" => "Test title 3", "disks" => [RSpec.configuration.db_ids[:disk]]}.to_json
				a.from_json(params)
				a.save

				# Check for updated relation through loop to allow for index to synchronize
				json = nil
				wait_for_relation(20.seconds) do
					b = DiskImage.find(RSpec.configuration.db_ids[:disk_image], {:select => :full})
					json = JSON.parse(b.to_json)
					json["disks"].size > 0 
				end
				expect(json["disks"].size).to eq 1
			end
		end
	end
end