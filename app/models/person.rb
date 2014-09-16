class Person < Authority
TYPE="person"

attr_datastream :eac, :authorized_forename, :authorized_surname, :startdate, :enddate
scope :brief, :authorized_forename, :startdate
scope :full, :title, :authorized_forename, :authorized_surname, :startdate, :enddate