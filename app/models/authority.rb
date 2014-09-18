class Authority < DarcFedoraObject

  attr_datastream :eac, :type, :startdate, :enddate
  attr_datastream :relations, :archives
  scope :full, :title, :type, :startdate, :enddate, :archives
  scope :update, :title, :type, :startdate, :enddate
  scope :brief, :title, :type, :startdate

  validates :type, inclusion: { in: %w(person corporation family), message: "#{@type} is not a valid value." }

  
  def initialize id, obj, scope="full"
    super
    load
  end
end
