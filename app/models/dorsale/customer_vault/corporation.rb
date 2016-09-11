class Dorsale::CustomerVault::Corporation < Dorsale::CustomerVault::Person
  serialize      :data,  Dorsale::CustomerVault::CorporationData
  def_delegators :data, *Dorsale::CustomerVault::CorporationData.methods_to_delegate

  validates :corporation_name, presence: true

  def name
    corporation_name
  end

  def name=(corporation_name)
    self.corporation_name = corporation_name
  end

  private def first_name;  raise NoMethodError; end
  private def first_name=; raise NoMethodError; end
  private def last_name;   raise NoMethodError; end
  private def last_name=;  raise NoMethodError; end
end
