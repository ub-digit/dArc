class Api::ContentFileInfosController < Api::ApiController

  def index
    @objects = ContentFileInfo.find(params[:disk_image].to_i, params[:parent].to_i)
    if !@objects.nil?
      render json: {'content_file_infos' => @objects}, status: 200
    else
      #render json: {error: "No objects found"}, status: 404
    end
  rescue => error
    render json: {error: "No objects found"}, status: 404
  end

end