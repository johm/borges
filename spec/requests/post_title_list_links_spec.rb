require 'spec_helper'

describe "PostTitleListLinks" do
  describe "GET /post_title_list_links" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get post_title_list_links_path
      response.status.should be(200)
    end
  end
end
