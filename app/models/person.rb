class Person < Authority
TYPE="person"

attr_datastream :eac, :type, :authorized_forename, :authorized_surname, :startdate, :enddate
scope :brief, :type, :authorized_forename, :startdate
scope :full, :type, :title, :authorized_forename, :authorized_surname, :startdate, :enddate

def self.fedora_model_name
 'Authority'
end

end