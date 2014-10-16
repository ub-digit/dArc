class Api::PersonsController < Api::FedoraObjectController

  def type_class
    Person
  end

  # Override of pluralization to not get "people"
  def type_list_name
    "persons"
  end

end
