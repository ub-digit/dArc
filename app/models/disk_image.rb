class DiskImage < DarcFedoraObject

  attr_datastream :relations_out_subset, :disks
  scope :full, :disks
  scope :create, :disks

  validates :disks, :length => { :minimum => 1, :maximum => 1}, allow_nil: true

  def initialize id, obj, scope="brief", new_record = false
     super
     load
  end

	def volumes
		coll = MongodbClient.new.mongo_collection
		docs = coll.aggregate( [ { '$match' => { 'disk_image' => 42} }, { '$group' => { '_id' => "$volume" } } ] )
      
		docs.map { |doc| doc['_id'] }
	end
end
