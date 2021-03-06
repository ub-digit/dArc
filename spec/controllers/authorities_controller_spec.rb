require 'rails_helper'

RSpec.describe Api::AuthoritiesController, :type => :controller do
	before :each do
		@api_key = Rails.application.config.api_key
	end

	describe "GET show" do 
		context "with existing id" do 
			it "returns a json message" do 
				get :show, api_key: @api_key, id: RSpec.configuration.db_ids[:authority]
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
				expect(json["authorities"]).to_not be nil
				expect(json["authorities"]).to be_an(Array)
			end
		end
	end

	describe "PUT update" do
		context "with valid attributes" do
			it "should return a success message" do
				put :update, api_key: @api_key, id: RSpec.configuration.db_ids[:authority], authority: {startdate: "1337"}.to_json
				expect(response.status.to_i == 200).to be true
			end
		end
	end

	describe "POST create" do
		context "with valid attributes" do
			it "should return a success message" do
				post :create, api_key: @api_key, authority: {type: "person", title: "TestPerson", startdate: "1337", enddate: "1408"}
				@@temp_id = json["authority"]["id"]
				expect(response.status.to_i).to eq 200
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