class Archive < DarcFedoraObject

  attr_datastream :relations_out_dependent, :authorities
  scope :full, :authorities
  #relation :dependentOf, :authority

  def initialize id, obj, scope="brief"
     super
     load
  end
end
