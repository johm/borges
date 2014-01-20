require "spec_helper"

describe EventStaffersController do
  describe "routing" do

    it "routes to #index" do
      get("/event_staffers").should route_to("event_staffers#index")
    end

    it "routes to #new" do
      get("/event_staffers/new").should route_to("event_staffers#new")
    end

    it "routes to #show" do
      get("/event_staffers/1").should route_to("event_staffers#show", :id => "1")
    end

    it "routes to #edit" do
      get("/event_staffers/1/edit").should route_to("event_staffers#edit", :id => "1")
    end

    it "routes to #create" do
      post("/event_staffers").should route_to("event_staffers#create")
    end

    it "routes to #update" do
      put("/event_staffers/1").should route_to("event_staffers#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/event_staffers/1").should route_to("event_staffers#destroy", :id => "1")
    end

  end
end
