module TestHelper

	def json
		@json ||= JSON.parse(response.body)
	end

	def config_init
		Rails.application.config.api_key = "test_key"
	end
end