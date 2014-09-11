class Model < DarcFedora

  @@models = {}

  def self.find id
    if @@models[id] == nil
      @@models[id] = DarcFedora.find(id)
    end
    @@models[id]
  end

end
