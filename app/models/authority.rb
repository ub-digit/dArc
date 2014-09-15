class Authority < DarcFedora

  #attr_datastream :dc, :title
  attr_datastream :eac, :authorized_forename, :authorized_surname, :startdate, :enddate
  scope :brief, :authorized_forename, :startdate
  scope :full, :authorized_forename, :authorized_surname, :startdate, :enddate

  def initialize id, obj, scope="brief"
    super
    load
  end
end
