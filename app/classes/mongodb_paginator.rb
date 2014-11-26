class MongodbPaginator

  # Extract one page of entries from a MongoDB cursor and compute pagination metadata for it.
  #
  # Parameters:
  # +cursor+:: A +Mongo::Cursor+ to a result set. This will be modified.
  # +page+:: An +Integer+ designating which page to extract. 1 is the first page.
  # +page+:: An +Integer+ designating the page size
  #
  # Returns a hash with the following keys and values:
  # +data+:: The +cursor+ parameter passed to the function, with skip and limit set.
  # +meta+:: A hash containing pagination metadata.
  #
  # The +meta+ hash has the following keys and values:
  # +page+:: One-indexed page number of the returned set
  # +pages+:: Total number of pages in the matched set
  # +per_page+:: Number of items per page
  # +next+:: One-indexed number of the next page, or `nil` if not applicable
  # +previous+:: One-indexed number of the previous page, or `nil` if not applicable
  # +items+:: The number of items in the returned set
  # +first_item+:: One-indexed number of the first item returned, or nil if not applicable
  # +last_item+:: One-indexed number of the last item returned, or nil if not applicable
  # +total_items+:: Total number of items in the matched set
  def self.paginate(cursor, page, page_size)
    page_index = page - 1
    begin_index = page_index * page_size

    cursor.skip(begin_index)
    cursor.limit(page_size)

    num_returned = cursor.count(true)
    num_total = cursor.count(false)

    total_pages = num_total / page_size + if num_total % page_size == 0 then 0 else 1 end

    meta = {
      page: page,
      pages: total_pages,
      per_page: page_size,
      total_items: num_total,
    }

    {
      data: cursor,
      meta: meta.merge(
        if num_returned == 0 then {
          next: if page < 1 then 1 else nil end,
          previous: if page > total_pages then total_pages else nil end,
          items: 0,
          first_item: nil,
          last_item: nil,
        } else {
          next: if page == total_pages then nil else page + 1 end,
          previous: if page == 1 then nil else page - 1 end,
          items: num_returned,
          first_item: begin_index + 1,
          last_item: begin_index + num_returned,
        } end
      ),
    }
  end

end
