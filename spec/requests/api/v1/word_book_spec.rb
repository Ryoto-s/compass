require 'rails_helper'

RSpec.describe "Api::V1::WordBooks", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/api/v1/word_book/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /find" do
    it "returns http success" do
      get "/api/v1/word_book/find"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/word_book/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /add" do
    it "returns http success" do
      get "/api/v1/word_book/add"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/api/v1/word_book/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/api/v1/word_book/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      get "/api/v1/word_book/delete"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /answer" do
    it "returns http success" do
      get "/api/v1/word_book/answer"
      expect(response).to have_http_status(:success)
    end
  end

end
