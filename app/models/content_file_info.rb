require 'mongo'

class ContentFileInfo
  attr_reader :hash

  @@mongo_coll = nil

  def initialize hash
    @hash = hash
  end
  
  def save
    unless @hash == nil
      MongodbClient.new.mongo_collection.insert(@hash)
    end
  end
  
  def self.find id_filter, opts
      docs = MongodbClient.new.mongo_collection.find(make_filter_query(id_filter, opts))

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

  def self.all_categories id_filter
    docs = MongodbClient.new.mongo_collection.aggregate [
      { '$match' => make_filter_query(id_filter, {}) },
      { '$group' => { '_id' => "$categories" } },
    ]

    categories = Set.new docs.map { |doc| doc['_id'] }.flatten
    categories.delete nil
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
