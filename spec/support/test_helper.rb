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
			invalid: -7,
			authority: 25,
			archive: 26,
			disk: 27,
			disk_image: 28,
			digital_document: 29,
			content_file: 30
		}
	end
end