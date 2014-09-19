class Api::ArchivesController < Api::FedoraObjectController

  def type_class
    Archive
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
