class DarcFedora
  attr_reader :obj
  include ActiveModel::Validations
  
  def initialize obj
  	 @obj = obj
  end

  def self.find id
  	fedora_connection = Rubydora.connect Rails.application.config.fedora_connection
    self.new fedora_connection.find(Rails.application.config.namespace_prefix + id.to_s)
  rescue => error
    return nil	
  end

  def self.find_by_id
  end

  def self.all
  end


end
