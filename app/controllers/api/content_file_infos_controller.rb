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

    opts = { showDeleted: params[:showDeleted]=='true', hideDirs: params[:hideDirs]=='true', extFilter: params[:extFilter] }
    @objects = ContentFileInfo.find(id_filter, opts)
    if !@objects.nil?
      if page_size == -1
        render json: {
            content_file_infos: @objects,
            meta: {}
          },
          status: 200
      else
        paginated = MongodbPaginator.paginate @objects, page, page_size

        render json: {
            content_file_infos: paginated[:data],
            meta: {
              pagination: paginated[:meta],
            }
          },
          status: 200
      end
    else
      #render json: {error: "No objects found"}, status: 404
    end
  rescue => error
    render json: {error: "No objects found"}, status: 404
  end

end