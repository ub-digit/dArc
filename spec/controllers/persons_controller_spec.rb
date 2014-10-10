require 'rails_helper'

RSpec.configure do |c|
	c.include TestHelper
end

RSpec.describe Api::PersonsController, :type => :controller do
	before :each do
		@api_key = Rails.application.config.api_key
	end

end