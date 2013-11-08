require "spec_helper"

describe EventLocationsController do
  describe "routing" do

    it "routes to #index" do
      get("/event_locations").should route_to("event_locations#index")
    end

    it "routes to #new" do
      get("/event_locations/new").should route_to("event_locations#new")
    end

    it "routes to #show" do
      get("/event_locations/1").should route_to("event_locations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/event_locations/1/edit").should route_to("event_locations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/event_locations").should route_to("event_locations#create")
    end

    it "routes to #update" do
      put("/event_locations/1").should route_to("event_locations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/event_locations/1").should route_to("event_locations#destroy", :id => "1")
    end

  end
end
