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

	def db_ids 
		{
			authority_model_id: "info:fedora/darc:31",
			invalid: -7,
			authority: 37,
			archive: 38,
			disk: 39,
			disk_image: 40,
			digital_document: 41,
			content_file: 42
		}
	end
end