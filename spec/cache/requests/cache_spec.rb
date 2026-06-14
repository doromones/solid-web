# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SolidWebUi::Cache", type: :request do
  def create_entry(key:, bytes:, hash:)
    SolidCache::Entry.create!(key: key, value: "x" * bytes, byte_size: bytes, key_hash: hash)
  end

  # Write through the cache store so the stored bytes are a real cache envelope,
  # exactly as the host app's Rails.cache would produce them.
  def cache_store
    @cache_store ||= ActiveSupport::Cache.lookup_store(:solid_cache_store)
  end

  def seed_cache(key, value)
    cache_store.write(key, value)
    SolidCache::Entry.order(:id).last
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
    it "renders the key and the decoded value" do
      entry = seed_cache("users/7/profile", "hello-cached-value")

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

    it "creates an entry readable through the cache" do
      post "/admin/solid_cache/entries", params: { key: "greeting", value: "hello" }

      expect(response).to redirect_to("/admin/solid_cache/entries")
      expect(cache_store.read("greeting")).to eq("hello")
    end

    it "creates an entry with expiry and version metadata" do
      post "/admin/solid_cache/entries",
           params: { key: "greeting", value: "hello", expires_at: "2027-03-04 05:06:07", version: "v1" }

      entry = SolidCache::Entry.order(:id).last
      decoded = cache_store.send(:deserialize_entry, entry.value)
      expect(Time.at(decoded.expires_at).utc.strftime("%Y-%m-%d %H:%M:%S")).to eq("2027-03-04 05:06:07")
      expect(cache_store.read("greeting", version: "v1")).to eq("hello")
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
    it "renders an editable form for a plain-string value with metadata fields" do
      entry = seed_cache("k", "editable text")

      get "/admin/solid_cache/entries/#{entry.id}/edit"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("editable text", "Save changes", "Expires at", "Version")
    end

    it "shows a non-string value read-only but still allows metadata editing" do
      entry = seed_cache("h", { "a" => 1 })

      get "/admin/solid_cache/entries/#{entry.id}/edit"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("read-only", "Save changes", "Expires at")
    end

    it "shows an undecodable value as read-only without crashing" do
      blob = (+"\xC3\x28raw\x00bytes").force_encoding(Encoding::BINARY)
      SolidCache::Entry.write("bin", blob)
      entry = SolidCache::Entry.order(:id).last

      get "/admin/solid_cache/entries/#{entry.id}/edit"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("couldn&#39;t be decoded").or include("couldn't be decoded")
      expect(response.body).not_to include("Save changes")
    end

    it "updates the value, keeping it cache-readable" do
      entry = seed_cache("k", "old")

      patch "/admin/solid_cache/entries/#{entry.id}", params: { value: "new" }

      expect(response).to redirect_to("/admin/solid_cache/entries/#{entry.id}")
      expect(cache_store.read("k")).to eq("new")
    end

    it "edits expiry and version metadata" do
      entry = seed_cache("k", "v")

      patch "/admin/solid_cache/entries/#{entry.id}",
            params: { value: "v", expires_at: "2027-03-04 05:06:07", version: "v2" }

      expect(response).to redirect_to("/admin/solid_cache/entries/#{entry.id}")
      decoded = cache_store.send(:deserialize_entry, entry.reload.value)
      expect(Time.at(decoded.expires_at).utc.strftime("%Y-%m-%d %H:%M:%S")).to eq("2027-03-04 05:06:07")
      expect(cache_store.read("k", version: "v2")).to eq("v")
      expect(cache_store.read("k", version: "wrong")).to be_nil
    end

    it "preserves a non-string value while editing only its metadata" do
      entry = seed_cache("h", { "a" => 1 })

      patch "/admin/solid_cache/entries/#{entry.id}", params: { value: "ignored", version: "v9" }

      expect(response).to redirect_to("/admin/solid_cache/entries/#{entry.id}")
      expect(cache_store.read("h", version: "v9")).to eq({ "a" => 1 })
    end

    it "rejects an unparseable expiry" do
      entry = seed_cache("k", "keep")

      patch "/admin/solid_cache/entries/#{entry.id}", params: { value: "x", expires_at: "not-a-date" }

      expect(response).to redirect_to("/admin/solid_cache/entries/#{entry.id}/edit")
      expect(cache_store.read("k")).to eq("keep")
    end

    it "is forbidden when editing is disabled" do
      entry = seed_cache("k", "v")
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
