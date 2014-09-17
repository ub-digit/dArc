class Authority < DarcFedoraObject

attr_datastream :eac, :type, :startdate, :enddate
attr_datastream :relations, :archives
scope :full, :title, :type, :startdate, :enddate, :archives
scope :brief, :title, :type, :startdate

  def initialize id, obj, scope="full"
    super
    load
  end
end
