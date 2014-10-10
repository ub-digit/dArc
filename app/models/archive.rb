class Archive < DarcFedoraObject

  attr_datastream :relations_out_dependent, :authorities
  attr_datastream :relations_in_part, :disks
  attr_datastream :ead, :unittitle, :unitdate, :abstract, :unitid
  scope :full, :authorities, :disks, :unittitle, :unitdate, :unitid, :abstract 
  scope :update, :authorities, :unittitle, :unitdate, :unitid, :abstract
  scope :brief, :unittitle, :unitdate, :unitid
  scope :create, :authorities, :unittitle, :unitdate, :unitid, :abstract

  def initialize id, obj, scope=:full
     super
     load
  end
end
