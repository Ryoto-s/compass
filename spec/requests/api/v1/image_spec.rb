require 'rails_helper'

RSpec.describe "Api::V1::Images", type: :request do
  describe "GET /add" do
    it "returns http success" do
      get "/api/v1/image/add"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/image/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/api/v1/image/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/api/v1/image/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/api/v1/image/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
