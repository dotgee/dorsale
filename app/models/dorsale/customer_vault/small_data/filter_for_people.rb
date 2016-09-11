class Dorsale::CustomerVault::SmallData::FilterForPeople < ::Dorsale::SmallData::Filter
  STRATEGIES = {
    "tags" => ::Dorsale::CustomerVault::SmallData::FilterStrategyByTags.new
  }
end
