require 'rails_helper'

RSpec.configure do |c|
	c.include TestHelper
end

RSpec.describe Api::AuthoritiesController, :type => :controller do
	before :each do
		config_init
		@api_key = Rails.application.config.api_key
	end

	describe "GET show" do 
		context "with existing id" do 
			it "returns a json message" do 
				get :show, api_key: @api_key, id: db_ids[:authority]
				expect(response.status.to_i == 200).to be true
			end 
		end
		context "with a non existing id" do 
			it "returns a error message" do 
				get :show, api_key: @api_key, id: db_ids[:invalid]
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
				put :update, api_key: @api_key, id: db_ids[:authority], authority: {startdate: "1337"}.to_json
				expect(response.status.to_i == 200).to be true
			end
		end
	end
end