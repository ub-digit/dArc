class Dataformats::Relations < Dataformats::Wrapper

  def archives= value
     @new_relations = value
  end

  def archives
     lookup
  end

  def authorities= value
     @new_relations = value
  end

  def authorities
     lookup
  end

  def disks= value
     @new_relations = value
  end

  def disks
     lookup
  end

  def disk_images= value
     @new_relations = value
  end

  def disk_images
     lookup
  end

  # uses sparql to search for objects related to this object. the type of relation and
  # the relation direction are controlled by the arguments
  def lookup_in_direction relation, direction_in
    obj_id = pid_to_fedora_id(@obj.pid)
  	fedora_connection = Rubydora.connect Rails.application.config.fedora_connection
  	if direction_in
      sparql = 'select ?m where { ?m <'+relation+'> <'+obj_id+'> }'
    else
      sparql = 'select ?m where { <'+obj_id+'> <'+relation+'> ?m }'
    end
  	csv = fedora_connection.sparql(sparql)
  	csv['m'].collect{|id| fedora_id_to_numeric_id(id)}
  end

  # converts from 'darc:47' to 'info:fedora/darc:47'
  def pid_to_fedora_id pid
     'info:fedora/' + pid
  end

  # converts from 'info:fedora/darc:47' to 47
  def fedora_id_to_numeric_id fedora_id
     /.*:([0-9]+)/.match(fedora_id)[1].to_i
  end
end