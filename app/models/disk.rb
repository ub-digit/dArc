class Disk < DarcFedoraObject

  attr_datastream :relations_out_part, :archives
  attr_datastream :relations_in_subset, :disk_images
  scope :full, :archives, :disk_images
  scope :update, :archives
  scope :create, :archives
  scope :delete, :disk_images

  validates :archives, :length => { :minimum => 1, :maximum => 1}

  def initialize id, obj, scope="brief", new_record = false
     super
     load
  end

  def validate_for_delete
    if as_json[:disk_images].size > 0
      errors[:disk_images] << "Cannot delete object with existing relations: #{as_json[:disk_images]}"
    end
    super if defined?(super)
  end
end
