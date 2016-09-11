require "rails_helper"

describe ::Dorsale::Flyboy::FoldersController, type: :routing do
  describe "routing" do
    routes { ::Dorsale::Engine.routes }

    it "routes to #index" do
      expect(get("flyboy/folders")).to route_to("dorsale/flyboy/folders#index")
    end

    it "routes to #new" do
      expect(get("flyboy/folders/new")).to route_to("dorsale/flyboy/folders#new")
    end

    it "routes to #show" do
      expect(get("flyboy/folders/1")).to route_to("dorsale/flyboy/folders#show", id: "1")
    end

    it "routes to #edit" do
      expect(get("flyboy/folders/1/edit")).to route_to("dorsale/flyboy/folders#edit", id: "1")
    end

    it "routes to #create" do
      expect(post("flyboy/folders")).to route_to("dorsale/flyboy/folders#create")
    end

    it "routes to #update" do
      expect(patch("flyboy/folders/1")).to route_to("dorsale/flyboy/folders#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete("flyboy/folders/1")).to route_to("dorsale/flyboy/folders#destroy", id: "1")
    end

    it "routes to #open" do
      expect(patch("flyboy/folders/1/open")).to route_to("dorsale/flyboy/folders#open", id: "1")
    end

    it "routes to #close" do
      expect(patch("flyboy/folders/1/close")).to route_to("dorsale/flyboy/folders#close", id: "1")
    end

  end
end
