class Authority < DarcFedoraObject

attr_datastream :eac, :type, :startdate, :enddate
scope :full, :title, :type, :startdate, :enddate
scope :brief, :title, :type, :startdate

  def initialize id, obj, scope="full"
    super
    load
  end
end
