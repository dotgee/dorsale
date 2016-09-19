require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::PeopleController, type: :routing do
  routes { ::Dorsale::Engine.routes }

  describe "routing" do
    it "#index" do
      expect(get "/customer_vault/people").to \
      route_to("dorsale/customer_vault/people#index")
    end

    it "#corporations via get" do
      expect(get "/customer_vault/corporations").to \
      route_to("dorsale/customer_vault/people#corporations")
    end

    it "#individuals via get" do
      expect(get "/customer_vault/individuals").to \
      route_to("dorsale/customer_vault/people#individuals")
    end

    it "#activity" do
      expect(get "/customer_vault/people/activity").to \
      route_to("dorsale/customer_vault/people#activity")
    end

    it "#new person" do
      expect(get "/customer_vault/people/new").to \
      route_to("dorsale/customer_vault/people#new")
    end

    it "#new corporation" do
      expect(get "/customer_vault/corporations/new").to \
      route_to("dorsale/customer_vault/people#new")
    end

    it "#new individual" do
      expect(get "/customer_vault/individuals/new").to \
      route_to("dorsale/customer_vault/people#new")
    end

    it "#create person" do
      expect(post "/customer_vault/people").to \
      route_to("dorsale/customer_vault/people#create")
    end

    it "#create individual" do
      expect(post "/customer_vault/individuals").to \
      route_to("dorsale/customer_vault/people#create")
    end

    it "#create corporation" do
      expect(post "/customer_vault/corporations").to \
      route_to("dorsale/customer_vault/people#create")
    end

    it "#show" do
      expect(get "/customer_vault/people/1").to \
      route_to("dorsale/customer_vault/people#show", id: "1")
    end

    it "#edit" do
      expect(get "/customer_vault/people/1/edit").to \
      route_to("dorsale/customer_vault/people#edit", id: "1")
    end

    it "#update" do
      expect(patch "/customer_vault/people/1").to \
      route_to("dorsale/customer_vault/people#update", id: "1")
    end

    it "#destroy" do
      expect(delete "/customer_vault/people/1").to \
      route_to("dorsale/customer_vault/people#destroy", id: "1")
    end
  end # describe "routing"

  describe "route helpers" do
    it "#new_customer_vault_corporation_path" do
      expect(new_customer_vault_corporation_path).to \
      eq "/dorsale/customer_vault/corporations/new"
    end

    it "#new_customer_vault_individual_path" do
      expect(new_customer_vault_individual_path).to \
      eq "/dorsale/customer_vault/individuals/new"
    end

    it "#customer_vault_corporation_path" do
      expect(customer_vault_corporations_path).to \
      eq "/dorsale/customer_vault/corporations"
    end

    it "#customer_vault_individual_path" do
      expect(customer_vault_individuals_path).to \
      eq "/dorsale/customer_vault/individuals"
    end
  end # describe "route helpers"

end
