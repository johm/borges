require "spec_helper"

describe CopiesController do
  describe "routing" do

    it "routes to #index" do
      get("/copies").should route_to("copies#index")
    end

    it "routes to #new" do
      get("/copies/new").should route_to("copies#new")
    end

    it "routes to #show" do
      get("/copies/1").should route_to("copies#show", :id => "1")
    end

    it "routes to #edit" do
      get("/copies/1/edit").should route_to("copies#edit", :id => "1")
    end

    it "routes to #create" do
      post("/copies").should route_to("copies#create")
    end

    it "routes to #update" do
      put("/copies/1").should route_to("copies#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/copies/1").should route_to("copies#destroy", :id => "1")
    end

  end
end
