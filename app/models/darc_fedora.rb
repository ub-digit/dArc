class DarcFedora
  attr_reader :obj
  include ActiveModel::Validations
  
  def initialize obj
  	 @obj = obj
  end

  def self.find id
  	fedora_connetion = Rubydora.connect Rails.application.config.fedora_connection
    self.new fedora_connetion.find(id)
    
  end

  def self.find_by_id
  end

  def self.all
  end


end
