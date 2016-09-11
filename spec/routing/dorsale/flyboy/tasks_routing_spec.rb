require "rails_helper"

describe ::Dorsale::Flyboy::TasksController, type: :routing do
  describe "routing" do
    routes { ::Dorsale::Engine.routes }

    it "routes to #index" do
      expect(get("flyboy/tasks")).to route_to("dorsale/flyboy/tasks#index")
    end

    it "routes to #summary" do
      expect(get("flyboy/tasks/summary")).to route_to("dorsale/flyboy/tasks#summary")
    end

    it "routes to #new" do
      expect(get("flyboy/tasks/new")).to route_to("dorsale/flyboy/tasks#new")
    end

    it "routes to #show" do
      expect(get("flyboy/tasks/1")).to route_to("dorsale/flyboy/tasks#show", id: "1")
    end

    it "routes to #edit" do
      expect(get("flyboy/tasks/1/edit")).to route_to("dorsale/flyboy/tasks#edit", id: "1")
    end

    it "routes to #create" do
      expect(post("flyboy/tasks")).to route_to("dorsale/flyboy/tasks#create")
    end

    it "routes to #update" do
      expect(patch("flyboy/tasks/1")).to route_to("dorsale/flyboy/tasks#update", id: "1")
    end

    it "routes to #complete" do
      expect(patch("flyboy/tasks/1/complete")).to route_to("dorsale/flyboy/tasks#complete", id: "1")
    end

    it "routes to #snooze" do
      expect(patch("flyboy/tasks/1/snooze")).to route_to("dorsale/flyboy/tasks#snooze", id: "1")
    end

    it "routes to #destroy" do
      expect(delete("flyboy/tasks/1")).to route_to("dorsale/flyboy/tasks#destroy", id: "1")
    end

  end
end
