class Authority < DarcFedoraObject

  attr_datastream :eac, :type, :startdate, :enddate
  attr_datastream :relations_in_dependent, :archives
  scope :full, :type, :startdate, :enddate, :archives
  scope :update, :type, :startdate, :enddate
  scope :brief, :type, :startdate
  scope :create, :type, :startdate, :enddate
  scope :delete, :archives

  validates :type, inclusion: { in: %w(person corporation family), message: "#{@type} is not a valid value." }

  
  def initialize id, obj, scope=:full, new_record = false
    super
    load
  end

  def validate_for_delete
    if as_json[:archives].size > 0
      errors[:archives] << "Cannot delete object with existing relations: #{as_json[:archives]}"
    end
    super if defined?(super)
  end
end
