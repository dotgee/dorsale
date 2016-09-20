require "rails_helper"

RSpec.describe "i18n" do
  before :all do
    Rails.application.eager_load!
  end

  # TODO : test FR + EN

  ActiveRecord::Base.descendants.each do |model|
    next unless model.to_s.start_with?("Dorsale")

    it "should i18n #{model} model name" do
      i18n = model.model_name.human(default: "")
      expect(i18n).to be_present
    end

    model.column_names.each do |column_name|
      next if column_name.end_with?("_type")
      next if column_name.end_with?("_bak")
      next if column_name.start_with?("old_")

      # user_id => user
      column_name = column_name[0..-4] if column_name.end_with?("_id")

      it "should i18n #{model}##{column_name}" do
        i18n = model.human_attribute_name(column_name, default: "")
        expect(i18n).to be_present
      end
    end
  end
end
