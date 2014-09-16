class Authority < DarcFedoraObject

scope :full, :title, :startdate, :enddate
scope :brief, :title

  def initialize id, obj, scope="full"
    super
    load
  end
end
