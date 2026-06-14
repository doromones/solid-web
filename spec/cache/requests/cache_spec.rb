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
      expect(response.body).to include('id="swui-refresh-frame"', "data-swui-refresh")
    end
  end

  describe "GET /entries" do
    it "lists entries with their keys" do
      create_entry(key: "products/42", bytes: 50, hash: 99)

      get "/admin/solid_cache/entries"

      expect(response.body).to include("products/42")
    end
  end

  describe "GET /entries/:id (show)" do
    it "renders the full key and a value preview" do
      entry = create_entry(key: "users/7/profile", bytes: 12, hash: 123)
      entry.update!(value: "hello-cached-value")

      get "/admin/solid_cache/entries/#{entry.id}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("users/7/profile", "hello-cached-value", "Key hash")
    end
  end

  describe "creating entries" do
    it "renders the new-entry form" do
      get "/admin/solid_cache/entries/new"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("New cache entry", "swui-form")
    end

    it "creates an entry" do
      post "/admin/solid_cache/entries", params: { key: "greeting", value: "hello" }

      expect(response).to redirect_to("/admin/solid_cache/entries")
      expect(SolidCache::Entry.read("greeting")).to eq("hello")
    end

    it "rejects a blank key" do
      post "/admin/solid_cache/entries", params: { key: "", value: "x" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(SolidCache::Entry.count).to eq(0)
    end

    it "rejects a duplicate key" do
      SolidCache::Entry.write("dup", "first")

      post "/admin/solid_cache/entries", params: { key: "dup", value: "second" }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(SolidCache::Entry.read("dup")).to eq("first")
    end

    it "is forbidden when creation is disabled" do
      SolidWebUi::Cache.config.enable_create = false
      post "/admin/solid_cache/entries", params: { key: "k", value: "v" }
      expect(response).to have_http_status(:forbidden)
    ensure
      SolidWebUi::Cache.config.enable_create = true
    end
  end

  describe "editing entries" do
    it "renders the edit form for a text value" do
      SolidCache::Entry.write("k", "editable text")
      entry = SolidCache::Entry.order(:id).last

      get "/admin/solid_cache/entries/#{entry.id}/edit"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("editable text", "swui-form")
    end

    it "renders the edit form for a binary value without crashing" do
      blob = (+"\xC3\x28marshal\x00blob").force_encoding(Encoding::BINARY)
      SolidCache::Entry.write("bin", blob)
      entry = SolidCache::Entry.order(:id).last

      get "/admin/solid_cache/entries/#{entry.id}/edit"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("isn&#39;t valid UTF-8").or include("isn't valid UTF-8")
    end

    it "updates the value" do
      SolidCache::Entry.write("k", "old")
      entry = SolidCache::Entry.order(:id).last

      patch "/admin/solid_cache/entries/#{entry.id}", params: { value: "new" }

      expect(response).to redirect_to("/admin/solid_cache/entries/#{entry.id}")
      expect(SolidCache::Entry.read("k")).to eq("new")
    end

    it "is forbidden when editing is disabled" do
      SolidCache::Entry.write("k", "v")
      entry = SolidCache::Entry.order(:id).last
      SolidWebUi::Cache.config.enable_edit = false

      patch "/admin/solid_cache/entries/#{entry.id}", params: { value: "x" }
      expect(response).to have_http_status(:forbidden)
    ensure
      SolidWebUi::Cache.config.enable_edit = true
    end
  end

  describe "deleting an entry" do
    it "destroys the entry" do
      SolidCache::Entry.write("k", "v")
      entry = SolidCache::Entry.order(:id).last

      delete "/admin/solid_cache/entries/#{entry.id}"

      expect(response).to redirect_to("/admin/solid_cache/entries")
      expect(SolidCache::Entry.exists?(entry.id)).to be(false)
    end

    it "is forbidden when deletion is disabled" do
      SolidCache::Entry.write("k", "v")
      entry = SolidCache::Entry.order(:id).last
      SolidWebUi::Cache.config.enable_delete = false

      delete "/admin/solid_cache/entries/#{entry.id}"
      expect(response).to have_http_status(:forbidden)
    ensure
      SolidWebUi::Cache.config.enable_delete = true
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
