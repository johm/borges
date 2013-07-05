require 'spec_helper'

describe "TitleCategoryMemberships" do
  describe "GET /title_category_memberships" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get title_category_memberships_path
      response.status.should be(200)
    end
  end
end
