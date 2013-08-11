require "spec_helper"

describe SaleOrdersController do
  describe "routing" do

    it "routes to #index" do
      get("/sale_orders").should route_to("sale_orders#index")
    end

    it "routes to #new" do
      get("/sale_orders/new").should route_to("sale_orders#new")
    end

    it "routes to #show" do
      get("/sale_orders/1").should route_to("sale_orders#show", :id => "1")
    end

    it "routes to #edit" do
      get("/sale_orders/1/edit").should route_to("sale_orders#edit", :id => "1")
    end

    it "routes to #create" do
      post("/sale_orders").should route_to("sale_orders#create")
    end

    it "routes to #update" do
      put("/sale_orders/1").should route_to("sale_orders#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/sale_orders/1").should route_to("sale_orders#destroy", :id => "1")
    end

  end
end
