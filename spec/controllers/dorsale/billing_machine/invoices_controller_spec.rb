require "rails_helper"

describe Dorsale::BillingMachine::InvoicesController, type: :controller do
  routes { Dorsale::Engine.routes }

  let(:user) { create(:user) }
  before(:each) { sign_in(user) }

  describe "CSV export" do
    render_views

    it "should be ok" do
      3.times { create(:billing_machine_invoice_line) }
      get :index, params: {format: :csv}
      expect(response).to be_ok
      expect(response.body.split("\n").length).to eq 4 # headers + 3 invoices
    end
  end

end
