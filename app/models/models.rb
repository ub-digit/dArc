class Models
  attr_accessor :id_by_model_name, :model_name_by_id, :loaded
  @@loaded = false
  @@id_by_model_name = {}
  @@model_name_by_id = {}

  def self.get_all_models
    # return if already loaded
    if @@loaded then return end
    
  	fedora_connection = Rubydora.connect Rails.application.config.fedora_connection
  	csv = fedora_connection.sparql('select ?m where { ?m <info:fedora/fedora-system:def/model#hasModel> <info:fedora/fedora-system:ContentModel-3.0>}')
  	csv.each do |row|
  	  # the full id of the object
  	  id = row.to_s.strip

      # get the model name from the title
  	  model = DarcFedora.find(id)
  	  title = model.get_dc_value('title')
  	  model_name = title.sub('Content Model Object for ', '')

      # save model names and ids hashed to each other
  	  @@id_by_model_name[model_name] = id
  	  @@model_name_by_id[id] = model_name
  	end
  	# mark as loaded
  	@@loaded = true
  end
  
  def self.get_id_for_model_name model_name
    self.get_all_models
    @@id_by_model_name[model_name]
  end
  
  def self.get_model_name_for_id id
    self.get_all_models
    @@model_name_by_id[id]
  end

  def self.loaded
    @@loaded
  end

  def self.id_by_model_name
    @@id_by_model_name
  end

  def self.model_name_by_id
    @@model_name_by_id
  end
end