class Archive < DarcFedora
  attr_reader :title

  def initialize id, obj
     super
     
     dc = Dataformats::DC.new @obj
     @title = dc.get_dc_value 'title'
  end

  def as_json(opt)
     {
        title: @title
     }
  end
end
