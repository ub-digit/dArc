class DiskImage < DarcFedoraObject

  attr_datastream :relations_out_subset, :disks
  scope :full, :disks
  scope :update, :disks

  def initialize id, obj, scope="brief"
     super
     load
  end
end
