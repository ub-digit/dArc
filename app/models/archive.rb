class Archive < DarcFedoraObject

  attr_datastream :relations_out_dependent, :authorities
  attr_datastream :ead, :unittitle, :unitdate, :abstract, :unitid
  scope :full, :authorities, :unittitle, :unitdate, :unitid, :abstract 
  scope :update, :unittitle, :unitdate, :unitid, :abstract
  scope :brief, :unittitle, :unitdate, :unitid
  scope :create, :unittitle, :unitdate, :unitid, :abstract

  def initialize id, obj, scope=:full
     super
     load
  end
end
