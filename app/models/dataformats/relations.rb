class Dataformats::Relations < Dataformats::Wrapper

  def archives= value
     # NOT setting anything, this wrapper is read-only
  end

  def archives
     lookup_to 'info:fedora/fedora-system:def/relations-external#isDependentOf'
  end

  # looks up relations from this object of the specified type
  def lookup_from relation
    lookup relation, false
  end

  # looks up relations to this object of the specified type
  def lookup_to relation
    lookup relation, true
  end

  # uses sparql to search for objects related to this object. the type of relation and
  # the relation direction are controlled by the arguments
  def lookup relation, direction_to
    obj_id = pid_to_fedora_id(@obj.pid)
    puts obj_id
  	fedora_connection = Rubydora.connect Rails.application.config.fedora_connection
  	if direction_to
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