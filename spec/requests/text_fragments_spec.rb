require 'rails_helper'

RSpec.describe "TextFragments", :type => :request do
  describe "GET /text_fragments" do
    it "works! (now write some real specs)" do
      get text_fragments_path
      expect(response).to have_http_status(200)
    end
  end
end
