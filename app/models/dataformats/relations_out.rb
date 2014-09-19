class Dataformats::RelationsOut < Dataformats::Relations

  def add_archives id
    relation_add id
  end

  def remove_archives id
    relation_remove id
  end

  def add_authorities id
    relation_add id
  end

  def remove_authorities id
    relation_remove id
  end

  def relation_add id
     rels = @obj.relationship(relation_type)

     fedora_connection = Rubydora.connect Rails.application.config.fedora_connection
     other_obj = fedora_connection.find(DarcFedora.numeric_id_to_fedora_id(id))
     rels << other_obj
  end

  def relation_remove id
     rels = @obj.relationship(relation_type)

     matching_rels = rels.select{|rel| "info:fedora/#{rel.pid}" == DarcFedora.numeric_id_to_fedora_id(id)}
     rels.delete(matching_rels.first)
  end

  def lookup
    lookup_in_direction relation_type, false
  end

  class Dataformats::RelationsOut::Dependent < Dataformats::RelationsOut
    def relation_type
      'info:fedora/fedora-system:def/relations-external#isDependentOf'
    end
  end

  class Dataformats::RelationsOut::Part < Dataformats::RelationsOut
    def relation_type
      'info:fedora/fedora-system:def/relations-external#isPartOf'
    end
  end

  class Dataformats::RelationsOut::Subset < Dataformats::RelationsOut
    def relation_type
      'info:fedora/fedora-system:def/relations-external#isSubsetOf'
    end
  end
end