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
    if params[:page_size].nil?
      DEFAULT_PAGE_SIZE
    else
      Integer(params[:page_size])
    end
  end

  def index
    opts = { showDeleted: params[:showDeleted]=='true', extFilter: params[:extFilter] }
    @objects = ContentFileInfo.find(params[:disk_image].to_i, params[:volume].to_i, params[:parent].to_i, opts)
    if !@objects.nil?
      paginated = MongodbPaginator.paginate @objects, page, page_size

      render json: {
          content_file_infos: paginated[:data],
          meta: {
            pagination: paginated[:meta],
          }
        },
        status: 200
    else
      #render json: {error: "No objects found"}, status: 404
    end
  rescue => error
    render json: {error: "No objects found"}, status: 404
  end

end