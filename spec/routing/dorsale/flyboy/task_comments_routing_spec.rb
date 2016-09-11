require "rails_helper"

describe ::Dorsale::Flyboy::TaskCommentsController, type: :routing do
  describe "routing" do
    routes { ::Dorsale::Engine.routes }

    it "routes to #create" do
      expect(post("flyboy/task_comments")).to route_to("dorsale/flyboy/task_comments#create")
    end

  end
end
