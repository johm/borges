require "spec_helper"

describe InventoryCopyConfirmationsController do
  describe "routing" do

    it "routes to #index" do
      get("/inventory_copy_confirmations").should route_to("inventory_copy_confirmations#index")
    end

    it "routes to #new" do
      get("/inventory_copy_confirmations/new").should route_to("inventory_copy_confirmations#new")
    end

    it "routes to #show" do
      get("/inventory_copy_confirmations/1").should route_to("inventory_copy_confirmations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/inventory_copy_confirmations/1/edit").should route_to("inventory_copy_confirmations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/inventory_copy_confirmations").should route_to("inventory_copy_confirmations#create")
    end

    it "routes to #update" do
      put("/inventory_copy_confirmations/1").should route_to("inventory_copy_confirmations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/inventory_copy_confirmations/1").should route_to("inventory_copy_confirmations#destroy", :id => "1")
    end

  end
end
