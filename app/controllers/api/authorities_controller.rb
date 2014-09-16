class Api::AuthoritiesController < Api::ApiController

  def show
    @authority = Authority.find(params[:id].to_i)
    if !@authority.nil? 
      render json: {authority: @authority}, status: 200
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
  end

  def update
    @authority = Authority.find(params[:id].to_i, {:select => :full})
    if !@authority.nil? 
      @authority.from_json(request.raw_post)
      @authority.save
      render json: {authority: @authority}, status: 201
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
  end
end
