class Disk < DarcFedoraObject

  attr_datastream :ead, :item_unittitle, :item_unitdate, :item_unitid
  attr_datastream :relations_out_part, :archives
  attr_datastream :relations_in_subset, :diskimages
  scope :full, :archives, :diskimages, :item_unittitle, :item_unitdate, :item_unitid
  scope :update, :archives, :item_unittitle, :item_unitdate, :item_unitid
  scope :create, :archives, :item_unittitle, :item_unitdate, :item_unitid
  scope :delete, :diskimages

  validates :archives, :length => { :minimum => 1, :maximum => 1}
  validates_presence_of :item_unitid, :item_unittitle

  def initialize id, obj, scope="brief", new_record = false
     super
     load
  end

  def validate_for_delete
    if as_json[:diskimages].size > 0
      errors[:diskimages] << "Cannot delete object with existing relations: #{as_json[:diskimages]}"
    end
    super if defined?(super)
  end

  def generate_title
    @title = @item_unittitle.to_s + "[" + @item_unitid.to_s + "]"
  end
end
