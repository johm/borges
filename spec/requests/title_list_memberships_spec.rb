require 'spec_helper'

describe "TitleListMemberships" do
  describe "GET /title_list_memberships" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get title_list_memberships_path
      response.status.should be(200)
    end
  end
end
