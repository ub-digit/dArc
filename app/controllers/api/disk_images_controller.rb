class Api::DiskImagesController < Api::FedoraObjectController

  def type_class
    DiskImage
  end

  def serialize_object
    super.as_json.merge({
      volumes: @object.volumes,
    })
  end

end
