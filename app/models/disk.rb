class Disk < DarcFedoraObject

  attr_datastream :relations_out_part, :archives
  attr_datastream :relations_in_subset, :disk_images
  scope :full, :archives, :disk_images
  scope :update, :archives
  scope :create, :archives

  def initialize id, obj, scope="brief"
     super
     load
  end
end
