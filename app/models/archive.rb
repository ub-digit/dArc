class Archive < DarcFedoraObject

  #attr_datastream :ead
  scope :brief, :title
  scope :full, :title

  def initialize id, obj, scope="brief"
     super
     load
  end
end
