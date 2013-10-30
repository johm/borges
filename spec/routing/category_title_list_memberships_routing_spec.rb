require "spec_helper"

describe CategoryTitleListMembershipsController do
  describe "routing" do

    it "routes to #index" do
      get("/category_title_list_memberships").should route_to("category_title_list_memberships#index")
    end

    it "routes to #new" do
      get("/category_title_list_memberships/new").should route_to("category_title_list_memberships#new")
    end

    it "routes to #show" do
      get("/category_title_list_memberships/1").should route_to("category_title_list_memberships#show", :id => "1")
    end

    it "routes to #edit" do
      get("/category_title_list_memberships/1/edit").should route_to("category_title_list_memberships#edit", :id => "1")
    end

    it "routes to #create" do
      post("/category_title_list_memberships").should route_to("category_title_list_memberships#create")
    end

    it "routes to #update" do
      put("/category_title_list_memberships/1").should route_to("category_title_list_memberships#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/category_title_list_memberships/1").should route_to("category_title_list_memberships#destroy", :id => "1")
    end

  end
end
