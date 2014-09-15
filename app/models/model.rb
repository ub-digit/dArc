class Model < DarcFedora
  scope :brief
  scope :full

  @@models = {}

  def self.find id
    if @@models[id] == nil
      @@models[id] = DarcFedora.find(id)
    end
    @@models[id]
  end

end
