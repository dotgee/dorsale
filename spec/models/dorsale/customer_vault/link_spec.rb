require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::Link, type: :model do
  it "should have a valid factory" do
    link = build(:customer_vault_link)
    expect(link).to be_valid
  end

  it { should belong_to :alice }
  it { should belong_to :bob }

  it { should validate_presence_of :alice }
  it { should validate_presence_of :bob }
end

