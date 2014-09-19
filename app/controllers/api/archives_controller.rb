class Api::ArchivesController < Api::ApiController


  def index
    @archives = Archive.all({:select => :full})
    if !@archives.nil?
      render json: {archives: @archives}, status: 200
    else
      render json: {error: "No objects found"}, status: 404
    end
  #rescue => error
  #  render json: {error: "No objects found"}, status: 404
  end

  def create
    @archive = Archive.create()
    if !@authority.nil? 
      @archive.from_json(params[:person])
      unless @archive.save then
        render json: {error: "Could not create", errors: @archive.errors}, status: 400
        return
      end
      render json: {archive: @archive}, status: 200
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
   end


  def show
    @archive = Archive.find(params[:id].to_i, {:select => :full})
    if !@archive.nil? 
      render json: {archive: @archive}, status: 200
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
  end

  def update
    @archive = Archive.find(params[:id].to_i, {:select => :update})
    if !@archive.nil? 
      @archive.from_json(params[:archive])
      @archive.save
      render json: {archive: @archive}, status: 200
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
  end

  def add_authority
    @archive = Archive.find(params[:id].to_i, {:select => :update})
    if !@archive.nil? 
      @archive.relation_add_authorities(params[:authority_id])
      render json: {archive: @archive}, status: 200
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
  end

  def remove_authority
    @archive = Archive.find(params[:id].to_i, {:select => :update})
    if !@archive.nil? 
      @archive.relation_remove_authorities(params[:authority_id])
      render json: {archive: @archive}, status: 200
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
  end
end
