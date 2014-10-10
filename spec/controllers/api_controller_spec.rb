require 'rails_helper'

RSpec.describe Api::ApiController, :type => :controller do
	before :each do
		@api_key = Rails.application.config.api_key
	end

	#API key is disabled until a better solution is implemented
	
	# describe "GET check_connection" do 
	# 	context "with correct api_key" do 
	# 		it "returns a json message" do 
	# 			get :check_connection, api_key: @api_key
	# 			expect(json['status']['code'] == 0).to be true
	# 		end 
	# 	end
	# 	context "with incorrect api_key" do 
	# 		it "returns a json message" do 
	# 			get :check_connection, api_key: "wrong_key"
	# 			expect(json['status']['code'] == -1).to be true
	# 		end 
	# 	end
	# end

end
