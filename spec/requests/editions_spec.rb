require 'spec_helper'

describe "Editions" do
  describe "GET /editions" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get editions_path
      response.status.should be(200)
    end
  end
end
