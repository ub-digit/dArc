class DarcFedoraObject < DarcFedora
  attr_datastream :dc, :title
  scope :full, :title
  scope :brief, :title
  scope :update, :title
end