require "spec_helper"

describe TitleCategoryMembershipsController do
  describe "routing" do

    it "routes to #index" do
      get("/title_category_memberships").should route_to("title_category_memberships#index")
    end

    it "routes to #new" do
      get("/title_category_memberships/new").should route_to("title_category_memberships#new")
    end

    it "routes to #show" do
      get("/title_category_memberships/1").should route_to("title_category_memberships#show", :id => "1")
    end

    it "routes to #edit" do
      get("/title_category_memberships/1/edit").should route_to("title_category_memberships#edit", :id => "1")
    end

    it "routes to #create" do
      post("/title_category_memberships").should route_to("title_category_memberships#create")
    end

    it "routes to #update" do
      put("/title_category_memberships/1").should route_to("title_category_memberships#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/title_category_memberships/1").should route_to("title_category_memberships#destroy", :id => "1")
    end

  end
end
