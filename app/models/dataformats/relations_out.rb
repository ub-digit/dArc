class Dataformats::RelationsOut < Dataformats::Relations

  # looks up relations from this object of the specified type
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
