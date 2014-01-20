require "spec_helper"

describe EventShiftsController do
  describe "routing" do

    it "routes to #index" do
      get("/event_shifts").should route_to("event_shifts#index")
    end

    it "routes to #new" do
      get("/event_shifts/new").should route_to("event_shifts#new")
    end

    it "routes to #show" do
      get("/event_shifts/1").should route_to("event_shifts#show", :id => "1")
    end

    it "routes to #edit" do
      get("/event_shifts/1/edit").should route_to("event_shifts#edit", :id => "1")
    end

    it "routes to #create" do
      post("/event_shifts").should route_to("event_shifts#create")
    end

    it "routes to #update" do
      put("/event_shifts/1").should route_to("event_shifts#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/event_shifts/1").should route_to("event_shifts#destroy", :id => "1")
    end

  end
end
