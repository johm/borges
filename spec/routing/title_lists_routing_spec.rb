require "spec_helper"

describe TitleListsController do
  describe "routing" do

    it "routes to #index" do
      get("/title_lists").should route_to("title_lists#index")
    end

    it "routes to #new" do
      get("/title_lists/new").should route_to("title_lists#new")
    end

    it "routes to #show" do
      get("/title_lists/1").should route_to("title_lists#show", :id => "1")
    end

    it "routes to #edit" do
      get("/title_lists/1/edit").should route_to("title_lists#edit", :id => "1")
    end

    it "routes to #create" do
      post("/title_lists").should route_to("title_lists#create")
    end

    it "routes to #update" do
      put("/title_lists/1").should route_to("title_lists#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/title_lists/1").should route_to("title_lists#destroy", :id => "1")
    end

  end
end
