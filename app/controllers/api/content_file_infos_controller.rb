class Api::ContentFileInfosController < Api::ApiController

  DEFAULT_PAGE_SIZE = 50

  def page
    if params[:page].nil?
      1
    else
      Integer(params[:page])
    end
  end

  def page_size
    if params[:per_page].nil?
      DEFAULT_PAGE_SIZE
    else
      Integer(params[:per_page])
    end
  end

  def index
    id_filter = {disk_image_id: params[:disk_image].to_i}
    unless params[:volume].to_s.empty? then
      id_filter.merge!({volume_id: params[:volume].to_i})
    end
    unless params[:parent].to_s.empty? then
      id_filter.merge!({ parent_id: params[:parent].to_i })
    end

    opts = { showDeleted: params[:showDeleted]=='true',
             hideDirs: params[:hideDirs]=='true',
             extFilter: params[:extFilter],
             pathFilter: params[:pathFilter],
             posCategory: params[:posCategory],
             negCategory: params[:negCategory],
             sortField: params[:sortField],
             sortAsc: !(params[:sortOrder]=='desc') }

    all_categories = ContentFileInfo.all_categories id_filter

    @objects = ContentFileInfo.find(id_filter, opts)
    if !@objects.nil?
      if page_size < 0
        render json: {
            content_file_infos: @objects,
            meta: {
              all_categories: all_categories,
              filtered_categories: get_categories_in_cursor(@objects),
              returned_categories: [],
            }
          },
          status: 200
      elsif page_size == 0
        render json: {
          meta: {
            pagination: {
              page: nil,
              pages: nil,
              per_page: nil,
              total_items: @objects.count,
              next: nil,
              previous: nil,
              items: 0,
              first_item: nil,
              last_item: nil,
            },
            all_categories: all_categories,
            filtered_categories: get_categories_in_cursor(@objects),
            returned_categories: [],
          },
        }, status: 200
      else
        filtered_categories = get_categories_in_cursor @objects

        paginated = MongodbPaginator.paginate @objects, page, page_size

        returned_categories = get_categories_in_cursor paginated[:data]

        render json: {
            content_file_infos: paginated[:data],
            meta: {
              pagination: paginated[:meta],
            },
            all_categories: all_categories,
            filtered_categories: filtered_categories,
            returned_categories: returned_categories,
          },
          status: 200
      end
    else
      render json: {error: "No objects found"}, status: 404
    end
  rescue => error
    render json: {error: "No objects found"}, status: 404
  end

  def get_categories_in_cursor(cursor)
      categories = Set.new

      cursor.each { |item|
        if item['categories'].respond_to? 'each'
          categories |= item['categories']
        else
          categories.add item['categories']
        end
      }

      cursor.rewind!

      categories.subtract [nil, '']

      categories
  end

end