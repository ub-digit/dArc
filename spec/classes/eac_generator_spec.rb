require 'rails_helper'

RSpec.configure do |c|
	c.include TestHelper
end

RSpec.describe EacGenerator do
	before :each do
		config_init
	end

	describe "generate_from_json" do 
		context "with valid json document" do 
			it "returns a valid xml document" do 
				result = EacGenerator.generate_from_json(File.read(Rails.root.to_s+"/spec/fixtures/valid_authority.json"))
				expect(result).to be true
			end 
		end
	end

end
