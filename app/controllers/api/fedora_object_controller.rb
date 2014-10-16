class Api::FedoraObjectController < Api::ApiController

  def type_name
    type_class.name.downcase
  end

  def type_list_name
    type_name.pluralize
  end

  def index
    @objects = type_class.all({:select => :full})
    if !@objects.nil?
      render json: {type_list_name => @objects}, status: 200
    else
      render json: {error: "No objects found"}, status: 404
    end
  rescue => error
    render json: {error: "No objects found"}, status: 404
  end

  def create
    @object = type_class.create()
    if !@object.nil? 
      @object.from_json(params[type_name.to_sym])
      if @object.save
        render json: {type_name => @object}, status: 200
      else
        render json: {errors: @object.errors}, status: 422
      end
    else
      render json: {error: "Could not create object"}, status: 404
    end
  rescue => error
    render json: {error: "Could not create object #{error}"}, status: 404
  end


  def show
    @object = type_class.find(params[:id].to_i, {:select => :full})
    if !@object.nil? 
      render json: {type_name => @object}, status: 200
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
  end

  def update
    @object = type_class.find(params[:id].to_i, {:select => :update})
    if !@object.nil? 
      @object.from_json(params[type_name.to_sym])
      if @object.save
        render json: {type_name => @object}, status: 200
      else
        render json: {errors: @object.errors}, status: 422
      end
    else
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    end
  rescue => error
    render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
  end

  def purge
    @object = type_class.find(params[:id].to_i, {:select => :delete})
    if @object.delete
      render json: {}, status: 200
    else
      render json: {errors: @object.errors}, status: 422
    end
    rescue Rubydora::RecordNotFound => error
      render json: {error: "Could not find object with id: #{params[:id]}"}, status: 404
    rescue => error
      render json: {error: "Unknown error"}, status: 500
    end

  end
