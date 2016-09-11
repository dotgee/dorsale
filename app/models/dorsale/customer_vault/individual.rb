class Dorsale::CustomerVault::Individual < Dorsale::CustomerVault::Person
  serialize      :data,  Dorsale::CustomerVault::IndividualData
  def_delegators :data, *Dorsale::CustomerVault::IndividualData.methods_to_delegate

  validates :first_name, presence: true
  validates :last_name,  presence: true

  def name
    [self.last_name, self.first_name].join(", ")
  end

  private def corporation_name;  raise NoMethodError; end
  private def corporation_name=; raise NoMethodError; end
end
