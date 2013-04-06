require "spec_helper"

describe TitlesController do
  describe "routing" do

    it "routes to #index" do
      get("/titles").should route_to("titles#index")
    end

    it "routes to #new" do
      get("/titles/new").should route_to("titles#new")
    end

    it "routes to #show" do
      get("/titles/1").should route_to("titles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/titles/1/edit").should route_to("titles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/titles").should route_to("titles#create")
    end

    it "routes to #update" do
      put("/titles/1").should route_to("titles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/titles/1").should route_to("titles#destroy", :id => "1")
    end

  end
end
