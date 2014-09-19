module TestHelper

	def json
		@json ||= JSON.parse(response.body)
	end

	def config_init
		Rails.application.config.api_key = "test_key"
		Rails.application.config.ownercode = "test_owner"
		Rails.application.config.fedora_connection = Rails.application.config.fedora_test_connection
	end

	def db_ids 
		{
			authority_model_id: "info:fedora/darc:49",
			invalid: -7,
			authority: 107,
			archive: 108,
			disk: 109,
			disk_image: 110,
			digital_document: 111,
			content_file: 112
		}
	end

	# Returns a valid authroty object
	def get_valid_authority
		#get valid authority object
		string_id = Authority.numeric_id_to_fedora_id(db_ids[:authority])
		obj = Authority.fedora_connection.find(string_id)
		authority = Authority.new(string_id, obj)
		return authority
	end

	# Returns a valid authroty object
	def get_valid_archive
		#get valid authority object
		string_id = Archive.numeric_id_to_fedora_id(db_ids[:archive])
		obj = Archive.fedora_connection.find(string_id)
		archive = Archive.new(string_id, obj)
		return archive
	end
end