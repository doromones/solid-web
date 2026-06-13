# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SolidWebUi::Cache", type: :request do
  def create_entry(key:, bytes:, hash:)
    SolidCache::Entry.create!(key: key, value: "x" * bytes, byte_size: bytes, key_hash: hash)
  end

  describe "GET / (dashboard)" do
    it "renders cache statistics in the shared layout" do
      create_entry(key: "users/1", bytes: 100, hash: 1)
      create_entry(key: "users/2", bytes: 300, hash: 2)

      get "/admin/solid_cache"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("solid-web-ui")
      expect(response.body).to include("Entries")
      expect(response.body).to include("2") # entry count
    end
  end

  describe "GET /entries" do
    it "lists entries with their keys" do
      create_entry(key: "products/42", bytes: 50, hash: 99)

      get "/admin/solid_cache/entries"

      expect(response.body).to include("products/42")
    end
  end

  describe "DELETE /entries (clear)" do
    it "clears the cache when enabled" do
      create_entry(key: "k", bytes: 10, hash: 7)

      delete "/admin/solid_cache/entries"

      expect(SolidCache::Entry.count).to eq(0)
    end

    it "is forbidden when disabled" do
      SolidWebUi::Cache.config.enable_clear = false
      delete "/admin/solid_cache/entries"
      expect(response).to have_http_status(:forbidden)
    ensure
      SolidWebUi::Cache.config.enable_clear = true
    end
  end
end
