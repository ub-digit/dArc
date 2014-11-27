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
      ContentFileInfo.find({ 'disk_image_id' => disk_image_id, 'volume_id' => volume_id, 'parent_id' => parent_id}, opts)
  end
  
  def self.find id_filter, opts
      client = Mongo::MongoClient.new # defaults to localhost:27017
      db     = client['darc-content']
      coll   = db['dfxml']

      docs = coll.find(make_filter_query(id_filter, opts))

      if opts[:sortField].to_s != '' then
        if opts[:sortAsc] then
          sortOrder = 1
        else
          sortOrder = -1
        end

        docs = docs.sort( { opts[:sortField].to_s => sortOrder })
      end

      docs
  end

  def mongo_collection
      return @@mongo_coll unless @@mongo_coll == nil

      client = Mongo::MongoClient.new # defaults to localhost:27017
      db     = client['darc-content']
      @@mongo_coll   = db['dfxml']
      @@mongo_coll
  end

  private

  def self.make_filter_query id_filter, opts
      query = {'disk_image' => id_filter[:disk_image_id]}
      
      unless id_filter[:volume_id].to_s.empty? then
        query.merge!({ 'volume' => id_filter[:volume_id] })
      end
      unless id_filter[:parent_id].to_s.empty? then
        query.merge!({ 'parent_object' => id_filter[:parent_id] })
      end

      if !opts[:showDeleted] then
        query.merge!({ 'nlink' => 1})
      end
      if opts[:hideDirs] then
        query.merge!({ 'name_type' => 'r' })
      end
      if opts[:extFilter].to_s != '' then
        query.merge!({ '$or' => [ {'extension' => opts[:extFilter]}, { 'name_type' => {'$ne' => 'r'} } ] })
      end
      if opts[:pathFilter].to_s != '' then
        query.merge!({ 'filename' => Regexp.new(opts[:pathFilter].to_s) })
      end

      if opts[:posCategory].to_s != '' and opts[:negCategory].to_s != '' then
        query.merge!({ '$and' => [ { 'categories' => {'$in' => opts[:posCategory].split(',') }  }, { 'categories' => {'$nin' => opts[:negCategory].split(',') }  } ] })
      elsif opts[:posCategory].to_s != '' then
        query.merge!({ 'categories' => {'$in' => opts[:posCategory].split(',') }  })
      elsif opts[:negCategory].to_s != '' then
        query.merge!({ 'categories' => {'$nin' => opts[:negCategory].split(',') }  })
      end

      query
  end
end
