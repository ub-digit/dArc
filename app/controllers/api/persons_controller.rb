class Api::PersonsController < Api::ApiController


  def index
    @authorities = Person.all({:select => :full})
    if !@authorities.nil?
      render json: {persons: @authorities}, status: 200
    else
      render json: {error: "No objects found"}, status: 404
    end
  rescue => error
    render json: {error: "No objects found"}, status: 404
  end

  def create
    @authority = Person.create()
    if !@authority.nil? 
      @authority.from_json(params[:person])
      @authority.save
      render json: {person: @authority}, status: 200
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
   end


  def show
    @authority = Person.find(params[:id].to_i, {:select => :full})
    if !@authority.nil? 
      render json: {person: @authority}, status: 200
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
  end

  def update
    @authority = Person.find(params[:id].to_i, {:select => :full})
    if !@authority.nil? 
      @authority.from_json(params[:person])
      @authority.save
      render json: {person: @authority}, status: 200
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
  end
end
