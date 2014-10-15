class DarcFedoraObject < DarcFedora
  attr_datastream :dc, :id, :pid, :title
  scope :full, :id, :pid, :title
  scope :brief, :id, :pid, :title
  scope :update, :id, :pid, :title
  scope :create, :id, :pid, :title
  scope :delete
end