class Dataformats::Wrapper
	include ActiveModel::Validations

  def initialize obj
     @obj = obj
  end

  def validate
  	return []
  end

end