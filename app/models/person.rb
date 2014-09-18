class Person < Authority
  TYPE="person"

  attr_datastream :eac, :authorized_forename, :authorized_surname
  scope :brief, :authorized_forename
  scope :full, :authorized_forename, :authorized_surname

  def self.fedora_model_name
    'Authority'
  end

end