class Disk < DarcFedoraObject

  attr_datastream :relations_out_part, :archives
  attr_datastream :relations_in_subset, :disk_images
  scope :full, :archives, :disk_images
  scope :update, :archives
  scope :create, :archives

  validates :archives, :length => { :minimum => 1, :maximum => 1}

  def initialize id, obj, scope="brief", new_record = false
     super
     load
  end
end
