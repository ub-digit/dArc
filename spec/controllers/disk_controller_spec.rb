require 'rails_helper'

RSpec.describe Api::DisksController, :type => :controller do
	before :each do
		@api_key = Rails.application.config.api_key
	end

	describe "GET show" do 
		context "with existing id" do 
			it "returns a json message" do 
				get :show, api_key: @api_key, id: RSpec.configuration.db_ids[:disk]
				expect(response.status.to_i == 200).to be true
			end 
		end
		context "with a non existing id" do 
			it "returns a error message" do 
				get :show, api_key: @api_key, id: -2
				expect(response.status.to_i == 404).to be true
			end 
		end
	end

	describe "GET index" do
		context "for a valid model" do
			it "should return a list of objects" do
				get :index, api_key: @api_key
				expect(json["disks"]).to_not be nil
				expect(json["disks"]).to be_an(Array)
			end
		end
	end

	describe "PUT update" do
		context "with valid attributes" do
			it "should return a success message" do
				put :update, api_key: @api_key, id: RSpec.configuration.db_ids[:disk], disk: {unittitle: "Titel", unitdate: "Date", unitid: "DiskID"}.to_json
				expect(response.status.to_i == 200).to be true
			end
		end
	end

	describe "POST create" do
		context "with valid attributes" do
			it "should return a success message" do
				post :create, api_key: @api_key, disk: {title: nil, pid: nil, item_unittitle: "TestPerson", item_unitdate: "1337", item_unitid: "1408", archives: [RSpec.configuration.db_ids[:archive]]}
				@@temp_id = json["disk"]["id"]
				expect(response.status.to_i).to eq 200
				d = Disk.find(@@temp_id)
				expect(d).to_not be nil
			end
		end
	end

	describe "DELETE purge" do
		context "of an existing id" do
			it "should return a success message" do
				delete :purge, api_key: @api_key, id: @@temp_id
				expect(response.status.to_i).to eq 200
			end
		end
	end
end