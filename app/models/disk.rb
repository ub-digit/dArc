class Disk < DarcFedoraObject

  attr_datastream :relations_out_part, :archives
  attr_datastream :relations_in_subset, :diskimages
  scope :full, :archives, :diskimages
  scope :update, :archives
  scope :create, :archives
  scope :delete, :diskimages

  validates :archives, :length => { :minimum => 1, :maximum => 1}

  def initialize id, obj, scope="brief", new_record = false
     super
     load
  end

  def validate_for_delete
    if as_json[:diskimages].size > 0
      errors[:diskimages] << "Cannot delete object with existing relations: #{as_json[:diskimages]}"
    end
    super if defined?(super)
  end

  def generate_title
  end
end
