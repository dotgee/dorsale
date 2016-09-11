require "rails_helper"

RSpec.describe ::Dorsale::CustomerVault::PeopleController, type: :routing do
  routes { ::Dorsale::Engine.routes }

  describe "routing" do
    it "#index" do
      expect(get "/customer_vault/people").to \
      route_to("dorsale/customer_vault/people#index")
    end

    it "#list" do
      expect(get "/customer_vault/people/list").to \
      route_to("dorsale/customer_vault/people#list")
    end

    it "#activity" do
      expect(get "/customer_vault/people/activity").to \
      route_to("dorsale/customer_vault/people#activity")
    end

    it "#new" do
      expect(get "/customer_vault/people/new").to \
      route_to("dorsale/customer_vault/people#new")
    end

    it "#new corporation" do
      expect(get "/customer_vault/people/new/corporation").to \
      route_to("dorsale/customer_vault/people#new", type: "corporation")
    end

    it "#new individual" do
      expect(get "/customer_vault/people/new/individual").to \
      route_to("dorsale/customer_vault/people#new", type: "individual")
    end

    it "#create" do
      expect(post "/customer_vault/people").to \
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

  end
end
