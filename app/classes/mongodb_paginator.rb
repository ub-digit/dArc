class MongodbPaginator

  def self.paginate(cursor, page, page_size)
    page_index = page - 1
    begin_index = page_index * page_size

    cursor.skip(begin_index)
    cursor.limit(page_size)

    num_returned = cursor.count(true)
    num_total = cursor.count(false)

    total_pages = num_total / page_size + if num_total % page_size == 0 then 0 else 1 end

    {
      data: cursor,
      meta: if num_returned == 0 then {
          page: 0,
          pages: 0,
          per_page: page_size,
          next: nil,
          previous: nil,
          items: 0,
          first_item: nil,
          last_item: nil,
          total_items: 0,
        } else {
          page: page,
          pages: total_pages,
          per_page: page_size,
          next: if page == total_pages then nil else page + 1 end,
          previous: if page == 1 then nil else page - 1 end,
          items: num_returned,
          first_item: begin_index + 1,
          last_item: begin_index + num_returned,
          total_items: num_total,
        } end,
    }
  end

end
