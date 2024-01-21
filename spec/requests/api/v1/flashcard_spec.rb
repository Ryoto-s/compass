require 'rails_helper'

RSpec.describe "Api::V1::Flashcards", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/api/v1/flashcard/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /find" do
    it "returns http success" do
      get "/api/v1/flashcard/find"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/api/v1/flashcard/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /add" do
    it "returns http success" do
      get "/api/v1/flashcard/add"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/api/v1/flashcard/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/api/v1/flashcard/update"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      get "/api/v1/flashcard/delete"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /answer" do
    it "returns http success" do
      get "/api/v1/flashcard/answer"
      expect(response).to have_http_status(:success)
    end
  end

end
