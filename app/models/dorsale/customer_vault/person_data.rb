require "virtus"

class Dorsale::CustomerVault::PersonData
  include Virtus.model

  def self.dump(obj)
    JSON.dump(obj.attributes)
  end

  def self.load(json_string)
    new JSON.load(json_string)
  end

  def self.methods_to_delegate
    instance_methods - Dorsale::CustomerVault::PersonData.instance_methods
  end
end

