module TestHelper

	def json
		@json ||= JSON.parse(response.body)
	end

	def config_init
		Rails.application.config.api_key = "test_key"
		Rails.application.config.ownercode = "test_owner"
		Rails.application.config.fedora_connection = {
			:url => 'http://130.241.35.158:8080/fedora', :user => 'fedoraAdmin', :password => 'fedora'
		}
	end
end