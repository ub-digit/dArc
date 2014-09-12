class Authority < DarcFedora
#  attr_accessor :title, :authorized_forename, :authorized_surname, :type, :startdate, :enddate, :biography
  attr_datastream :dc, :titlex
  attr_datastream :eac, :authorized_forename, :authorized_surname, :startdate
  scope :brief, :title, :authorized_forename, :startdate
  scope :full, :title, :authorized_forename, :authorized_surname, :startdate

  def initialize id, obj, scope = :brief
     super
#     create_scope(@scope)
     return
     dc = Dataformats::DC.new @obj
     @title = dc.get_dc_value 'title'

     eac = Dataformats::EAC.new @obj
     @authorized_forename = eac.authorized_forename
     @authorized_surname = eac.authorized_surname
     @type = eac.type
     @startdate = eac.startdate
     @enddate = eac.enddate
     @biography = eac.biography
  end

  def fill_dataformat
     eac = Dataformats::EAC.new @obj
     eac.authorized_forename = @authorized_forename
     eac.authorized_surname = @authorized_surname
     eac.type = @type
     eac.startdate = @startdate
     eac.enddate = @enddate
     eac.biography = @biography
     
     eac
  end

  def save
     eac = fill_dataformat()
     
     eac.save()
  end
  
  def xxxas_json(opt)
     {
        title: @title,
        authorized_forename: @authorized_forename,
        authorized_surname: @authorized_surname,
        type: @type,
        startdate: @startdate,
        enddate: @enddate,
        biography: @biography
     }
  end

  def from_json(json)
     j = JSON.parse(json)
     @authorized_forename = j['authorized_forename']
     @authorized_surname = j['authorized_surname']
     @type = j['type']
     @startdate = j['startdate']
     @enddate = j['enddate']
     @biography = j['biography']
  end
end
