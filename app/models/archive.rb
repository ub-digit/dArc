class Archive < DarcFedoraObject

  attr_datastream :relations_out_dependent, :authorities
  attr_datastream :relations_in_part, :disks
  attr_datastream :ead, :unittitle, :unitdate, :abstract, :unitid
  scope :full, :authorities, :disks, :unittitle, :unitdate, :unitid, :abstract 
  scope :update, :authorities, :unittitle, :unitdate, :unitid, :abstract
  scope :brief, :unittitle, :unitdate, :unitid
  scope :create, :authorities, :unittitle, :unitdate, :unitid, :abstract
  scope :delete, :disks

  validates :authorities, :length => { :minimum => 1}

  def initialize id, obj, scope=:full, new_record = false
     super
     load
  end

  def validate_for_delete
    if as_json[:disks].size > 0
      errors[:disks] << "Cannot delete object with existing relations: #{as_json[:disks]}"
    end
    super if defined?(super)
  end

  def generate_title
    @title = @unittitle + " (" + @unitdate + ")"
  end
end
