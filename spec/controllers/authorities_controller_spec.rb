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
				get :show, api_key: @api_key, id: 7
				expect(json['status']['code'] == 0).to be true
			end 
		end
		context "with a non existing id" do 
			it "returns a error message" do 
				get :show, api_key: @api_key, id: -7
				expect(json['status']['code'] == -1).to be true
			end 
		end

	end

end
