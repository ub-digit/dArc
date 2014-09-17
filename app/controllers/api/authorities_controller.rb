class Api::AuthoritiesController < Api::ApiController


  def index
    @authorities = Authority.all({:select => :full})
    if !@authorities.nil?
      render json: {authorities: @authorities}, status: 200
    else
      render json: {error: "No objects found"}, status: 404
    end
  rescue => error
    render json: {error: "No objects found"}, status: 404
  end

  def show
    @authority = Authority.find(params[:id].to_i, {:select => :full})
    if !@authority.nil? 
      render json: {authority: @authority}, status: 200
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
  end

  def update
    @authority = Authority.find(params[:id].to_i, {:select => :update})
    if !@authority.nil? 
      @authority.from_json(request.raw_post)
      @authority.save
      render json: {authority: @authority}, status: 200
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
  end
end
