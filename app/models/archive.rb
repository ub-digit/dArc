class Archive < DarcFedoraObject

  attr_datastream :relations, :authorities
  scope :full, :authorities
  #relation :dependentOf, :authority

  def initialize id, obj, scope="brief"
     super
     load
  end
end
