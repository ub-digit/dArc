class Dataformats::RelationsIn < Dataformats::Relations

  # looks up relations from this object of the specified type
  def lookup
    lookup_in_direction relation_type, true
  end

  class Dataformats::RelationsIn::Dependent < Dataformats::RelationsIn
    def relation_type
      'info:fedora/fedora-system:def/relations-external#isDependentOf'
    end
  end

  class Dataformats::RelationsIn::Part < Dataformats::RelationsIn
    def relation_type
      'info:fedora/fedora-system:def/relations-external#isPartOf'
    end
  end

  class Dataformats::RelationsIn::Subset < Dataformats::RelationsIn
    def relation_type
      'info:fedora/fedora-system:def/relations-external#isSubsetOf'
    end
  end
end
