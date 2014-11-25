require 'json'

class MongodbClient

  @@mongo_coll = nil

  def mongo_collection
      return @@mongo_coll unless @@mongo_coll == nil

      client = Mongo::MongoClient.new # defaults to localhost:27017
      db     = client['darc-content']
      @@mongo_coll   = db['dfxml']
      @@mongo_coll
  end
end