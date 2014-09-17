class Authority < DarcFedoraObject

  attr_datastream :relations, :archives
scope :full, :title, :startdate, :enddate, :archives
scope :brief, :title, :startdate

  def initialize id, obj, scope="full"
    super
    load
  end
end
