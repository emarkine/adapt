# require 'rails_helper'

RSpec.describe "Parts", type: :request do
  describe "GET /parts" do
    it "works" do
      authenticate
      get nodes_path
      expect(response).to have_http_status(200)
    end
  end
end
