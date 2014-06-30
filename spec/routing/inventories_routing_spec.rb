require "spec_helper"

describe InventoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/inventories").should route_to("inventories#index")
    end

    it "routes to #new" do
      get("/inventories/new").should route_to("inventories#new")
    end

    it "routes to #show" do
      get("/inventories/1").should route_to("inventories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/inventories/1/edit").should route_to("inventories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/inventories").should route_to("inventories#create")
    end

    it "routes to #update" do
      put("/inventories/1").should route_to("inventories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/inventories/1").should route_to("inventories#destroy", :id => "1")
    end

  end
end
