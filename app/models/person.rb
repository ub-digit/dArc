class Person < Authority
  TYPE="person"

  attr_datastream :eac, :authorized_forename, :authorized_surname
  scope :brief, :title
  scope :full, :authorized_forename, :authorized_surname
  scope :update, :authorized_forename, :authorized_surname
  scope :create, :authorized_forename, :authorized_surname

  def self.fedora_model_name
    'Authority'
  end

  def generate_title
  	@title = @authorized_forename + " " +  @authorized_surname + " (" + @startdate + " - " + @enddate +  ")"
  end

end