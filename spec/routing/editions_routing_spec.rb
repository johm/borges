require "spec_helper"

describe EditionsController do
  describe "routing" do

    it "routes to #index" do
      get("/editions").should route_to("editions#index")
    end

    it "routes to #new" do
      get("/editions/new").should route_to("editions#new")
    end

    it "routes to #show" do
      get("/editions/1").should route_to("editions#show", :id => "1")
    end

    it "routes to #edit" do
      get("/editions/1/edit").should route_to("editions#edit", :id => "1")
    end

    it "routes to #create" do
      post("/editions").should route_to("editions#create")
    end

    it "routes to #update" do
      put("/editions/1").should route_to("editions#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/editions/1").should route_to("editions#destroy", :id => "1")
    end

  end
end
