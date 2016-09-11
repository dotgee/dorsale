class Dorsale::Flyboy::SmallData::FilterForFolders < ::Dorsale::SmallData::Filter
  STRATEGIES = {
    "fb_status" => ::Dorsale::Flyboy::SmallData::FilterStrategyByStatus.new,
  }
end
