require 'rails_helper'

RSpec.describe ::Dorsale::ExpenseGun::Category, type: :model  do
  it { is_expected.to validate_presence_of :name }

  it "category factory should be valid?" do
    expect(build(:expense_gun_category)).to be_valid
  end
end
