class Api::PersonsController < Api::FedoraObjectController

  def type_class
    Person
  end

  def type_list_name
    "persons"
  end

end
