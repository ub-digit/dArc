require 'rails_helper'

RSpec.describe Models, :type => :model do

	describe "get_all_models" do
		context "with existsing model types" do
			it "should set class variables" do
				Models.get_all_models
				expect(Models.loaded).to be true
				expect(Models.id_by_model_name["Authority"]).to_not be nil
			end
		end
	end
		
end
