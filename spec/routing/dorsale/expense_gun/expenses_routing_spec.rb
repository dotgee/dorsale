require "rails_helper"

describe ::Dorsale::ExpenseGun::ExpensesController, type: :routing do
  routes { ::Dorsale::Engine.routes }

  describe "routing" do
    it "#index" do
      expect(get "/expense_gun/expenses").to \
      route_to("dorsale/expense_gun/expenses#index")
    end

    it "#new" do
      expect(get "/expense_gun/expenses/new").to \
      route_to("dorsale/expense_gun/expenses#new")
    end

    it "#create" do
      expect(post "/expense_gun/expenses").to \
      route_to("dorsale/expense_gun/expenses#create")
    end

    it "#show" do
      expect(get "/expense_gun/expenses/1").to \
      route_to("dorsale/expense_gun/expenses#show", id: "1")
    end

    it "#edit" do
      expect(get "/expense_gun/expenses/1/edit").to \
      route_to("dorsale/expense_gun/expenses#edit", id: "1")
    end

    it "#update" do
      expect(patch "/expense_gun/expenses/1").to \
      route_to("dorsale/expense_gun/expenses#update", id: "1")
    end

    it "#submit" do
      expect(patch "/expense_gun/expenses/1/submit").to \
      route_to("dorsale/expense_gun/expenses#submit", id: "1")
    end

    it "#accept" do
      expect(patch "/expense_gun/expenses/1/accept").to \
      route_to("dorsale/expense_gun/expenses#accept", id: "1")
    end

    it "#refuse" do
      expect(patch "/expense_gun/expenses/1/refuse").to \
      route_to("dorsale/expense_gun/expenses#refuse", id: "1")
    end

    it "#cancel" do
      expect(patch "/expense_gun/expenses/1/cancel").to \
      route_to("dorsale/expense_gun/expenses#cancel", id: "1")
    end

    it "#copy" do
      expect(get "/expense_gun/expenses/1/copy").to \
      route_to("dorsale/expense_gun/expenses#copy", id: "1")
    end

  end
end
