require "spec_helper"

describe PostTitleListLinksController do
  describe "routing" do

    it "routes to #index" do
      get("/post_title_list_links").should route_to("post_title_list_links#index")
    end

    it "routes to #new" do
      get("/post_title_list_links/new").should route_to("post_title_list_links#new")
    end

    it "routes to #show" do
      get("/post_title_list_links/1").should route_to("post_title_list_links#show", :id => "1")
    end

    it "routes to #edit" do
      get("/post_title_list_links/1/edit").should route_to("post_title_list_links#edit", :id => "1")
    end

    it "routes to #create" do
      post("/post_title_list_links").should route_to("post_title_list_links#create")
    end

    it "routes to #update" do
      put("/post_title_list_links/1").should route_to("post_title_list_links#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/post_title_list_links/1").should route_to("post_title_list_links#destroy", :id => "1")
    end

  end
end
