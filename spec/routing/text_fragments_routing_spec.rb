require "rails_helper"

RSpec.describe TextFragmentsController, :type => :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/text_fragments").to route_to("text_fragments#index")
    end

    it "routes to #new" do
      expect(:get => "/text_fragments/new").to route_to("text_fragments#new")
    end

    it "routes to #show" do
      expect(:get => "/text_fragments/1").to route_to("text_fragments#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/text_fragments/1/edit").to route_to("text_fragments#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/text_fragments").to route_to("text_fragments#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/text_fragments/1").to route_to("text_fragments#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/text_fragments/1").to route_to("text_fragments#destroy", :id => "1")
    end
  end
end
