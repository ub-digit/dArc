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
  
  def self.find disk_image_id, parent_id
      client = Mongo::MongoClient.new # defaults to localhost:27017
      db     = client['darc-content']
      coll   = db['dfxml']

      docs = coll.find({'disk_image' => disk_image_id, 'parent_object' => parent_id})    

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
