require 'rails_helper'

RSpec.describe Models, :type => :model do
	before :each do
		config_init
	end

	describe "get_all_models" do
		context "with existsing model types" do
			it "should set class variables" do
				Models.get_all_models
				pp Models.id_by_model_name
				expect(Models.loaded).to be true
				expect(Models.id_by_model_name["Authority"]).to eq "info:fedora/darc:19"
			end
		end
	end
		
end
