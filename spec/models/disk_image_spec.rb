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
				a = DiskImage.create()
				a.from_json({"title" => "Test title 2", "disks" => [RSpec.configuration.db_ids[:disk]]}.to_json)
				expect(a.save).to be true
				b = DiskImage.find(a.as_json[:id], {:select => :delete})
				expect(b.delete).to be true
			end
		end
		context "with an invalid title" do
			it "should return false" do
				a = DiskImage.find(RSpec.configuration.db_ids[:disk_image], {:select => :update})
				a.from_json({"title" => ""}.to_json)
				expect(a.save).to be false
				expect(a.errors.messages.size).to eq 1
				b = DiskImage.find(RSpec.configuration.db_ids[:disk_image], {:select => :update})
				expect(b).to_not be nil
			end
		end
		context "with an empty disk array" do
			it "should return false" do
				a = DiskImage.create()
				a.from_json({"title" => "test", "disks" => []}.to_json)
				expect(a.save).to be false
				expect(a.errors.messages.size).to eq 1
			end
		end
		context "with a disk array with multiple entries" do
			it "should return false" do
				a = DiskImage.create()
				a.from_json({"title" => "test", "disks" => [RSpec.configuration.db_ids[:disk], RSpec.configuration.db_ids[:disk2]]}.to_json)
				id = a.as_json[:id]
				expect(a.save).to be false
				expect(a.errors.messages.size).to eq 1
				expect{DiskImage.find(id)}.to raise_error
			end
		end
	end
end