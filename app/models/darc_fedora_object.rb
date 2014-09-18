class DarcFedoraObject < DarcFedora
  attr_datastream :dc, :title
  scope :full, :title
end