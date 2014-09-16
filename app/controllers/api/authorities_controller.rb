class Api::AuthoritiesController < Api::ApiController

  def show
    @authority = Authority.find(params[:id].to_i)
    if !@authority.nil? 
      render json: {status: ResponseData::ResponseStatus.new("SUCCESS"), data: @authority}
    else
      render json: {status: ResponseData::ResponseStatus.new("FAIL").set_error("OBJECT_ERROR", "Could not find object with id: #{params[:id]}")}
    end
  end

  def update
    @authority = Authority.find(params[:id].to_i, {:select => :full})
    if !@authority.nil? 
      @authority.from_json(request.raw_post)
      @authority.save
      render json: {status: ResponseData::ResponseStatus.new("SUCCESS"), data: @authority}
    else
      render json: {status: ResponseData::ResponseStatus.new("FAIL").set_error("OBJECT_ERROR", "Could not find object with id: #{params[:id]}")}
    end

  end
end
