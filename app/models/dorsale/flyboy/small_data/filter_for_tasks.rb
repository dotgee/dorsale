class Dorsale::Flyboy::SmallData::FilterForTasks < ::Dorsale::SmallData::Filter
  STRATEGIES = {
    "fb_status" => ::Dorsale::Flyboy::SmallData::FilterStrategyByDone.new,
    "owner"     => ::Dorsale::SmallData::FilterStrategyByKeyValue.new("owner_id")
  }
end
