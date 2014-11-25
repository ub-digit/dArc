require 'mongo'

class ContentFileInfo
  attr_reader :hash

  @@mongo_coll = nil

  def initialize hash
    @hash = hash
  end
  
  def save
    unless @hash == nil
      #client = Mongo::MongoClient.new # defaults to localhost:27017
      #db     = client['darc-content']
      #coll   = db['dfxml']
      mongo_collection.insert(@hash)
    end
  end
  
  def self.find disk_image_id, volume_id, parent_id, opts
      client = Mongo::MongoClient.new # defaults to localhost:27017
      db     = client['darc-content']
      coll   = db['dfxml']

      query = {'disk_image' => disk_image_id, 'volume' => volume_id, 'parent_object' => parent_id}
      if !opts[:showDeleted] then
        query.merge!({ 'nlink' => 1})
      end
      if opts[:extFilter].to_s != '' then
        query.merge!({ '$or' => [ {'extension' => opts[:extFilter]}, { 'name_type' => {'$ne' => 'r'} } ] })
      end

      docs = coll.find(query)

      docs
  end

  def mongo_collection
      return @@mongo_coll unless @@mongo_coll == nil

      client = Mongo::MongoClient.new # defaults to localhost:27017
      db     = client['darc-content']
      @@mongo_coll   = db['dfxml']
      @@mongo_coll
  end
end
