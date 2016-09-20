class Dorsale::CustomerVault::SmallData::FilterForPeople < ::Dorsale::SmallData::Filter
  STRATEGIES = {
    "person_type" => ::Dorsale::SmallData::FilterStrategyByKeyValue.new(:type),
    "person_tags" => ::Dorsale::CustomerVault::SmallData::FilterStrategyByTags.new,
  }
end
