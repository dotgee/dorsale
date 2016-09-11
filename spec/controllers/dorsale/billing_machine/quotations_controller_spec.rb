require "rails_helper"

describe Dorsale::BillingMachine::QuotationsController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:user) { create(:user) }

  before(:each) { sign_in(user) }

  describe "#index" do
    it "stats should not include canceled quotations" do
      q1 = create(:billing_machine_quotation_line, quantity: 1, unit_price: 10)
      q1.quotation.update!(state: "pending")

      q2 = create(:billing_machine_quotation_line, quantity: 1, unit_price: 10)
      q2.quotation.update!(state: "canceled")

      get :index
      expect(assigns(:total_excluding_taxes)).to eq 10
    end

    it "stats should be 0 if no quotations" do
      get :index
      expect(assigns(:total_excluding_taxes)).to eq 0
      expect(assigns(:vat_amount)).to eq 0
      expect(assigns(:total_including_taxes)).to eq 0
    end
  end
end
