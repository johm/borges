require "spec_helper"

describe OwnersController do
  describe "routing" do

    it "routes to #index" do
      get("/owners").should route_to("owners#index")
    end

    it "routes to #new" do
      get("/owners/new").should route_to("owners#new")
    end

    it "routes to #show" do
      get("/owners/1").should route_to("owners#show", :id => "1")
    end

    it "routes to #edit" do
      get("/owners/1/edit").should route_to("owners#edit", :id => "1")
    end

    it "routes to #create" do
      post("/owners").should route_to("owners#create")
    end

    it "routes to #update" do
      put("/owners/1").should route_to("owners#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/owners/1").should route_to("owners#destroy", :id => "1")
    end

  end
end
