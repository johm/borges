require "spec_helper"

describe InvoicesController do
  describe "routing" do

    it "routes to #index" do
      get("/invoices").should route_to("invoices#index")
    end

    it "routes to #new" do
      get("/invoices/new").should route_to("invoices#new")
    end

    it "routes to #show" do
      get("/invoices/1").should route_to("invoices#show", :id => "1")
    end

    it "routes to #edit" do
      get("/invoices/1/edit").should route_to("invoices#edit", :id => "1")
    end

    it "routes to #create" do
      post("/invoices").should route_to("invoices#create")
    end

    it "routes to #update" do
      put("/invoices/1").should route_to("invoices#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/invoices/1").should route_to("invoices#destroy", :id => "1")
    end

  end
end
