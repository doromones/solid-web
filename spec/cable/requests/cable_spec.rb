# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SolidWebUi::Cable", type: :request do
  def broadcast(channel:, hash:, created_at: nil)
    msg = SolidCable::Message.create!(channel: channel, payload: "data", channel_hash: hash)
    msg.update_column(:created_at, created_at) if created_at
    msg
  end

  describe "GET / (dashboard)" do
    it "renders message and channel stats in the shared layout" do
      broadcast(channel: "chat:1", hash: 1)
      broadcast(channel: "chat:1", hash: 1)
      broadcast(channel: "presence", hash: 2)

      get "/admin/solid_cable"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("solid-web-ui")
      expect(response.body).to include("Messages")
      expect(response.body).to include("chat:1") # top channel
      expect(response.body).to include('id="swui-refresh-frame"', "data-swui-refresh")
    end
  end

  describe "GET /channels" do
    it "lists channels with their message counts" do
      broadcast(channel: "notifications", hash: 9)

      get "/admin/solid_cable/channels"

      expect(response.body).to include("notifications")
    end
  end

  describe "GET /channels/:channel_hash (show)" do
    it "lists recent messages for the channel" do
      broadcast(channel: "alerts", hash: 555)
      broadcast(channel: "alerts", hash: 555)
      broadcast(channel: "other", hash: 999)

      get "/admin/solid_cable/channels/555"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("alerts", "Recent messages")
      expect(response.body).not_to include("other")
    end

    it "raises RecordNotFound (→ 404 in a host app) for an unknown channel hash" do
      expect { get "/admin/solid_cable/channels/424242" }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "GET /messages/:id (show)" do
    it "renders the full payload of a single message" do
      msg = broadcast(channel: "alerts", hash: 555)
      msg.update_column(:payload, "the-complete-payload-body")

      get "/admin/solid_cable/messages/#{msg.id}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("the-complete-payload-body", "alerts")
    end
  end

  describe "DELETE /messages/trim" do
    it "trims messages older than the retention window" do
      broadcast(channel: "old", hash: 1, created_at: 2.days.ago)
      broadcast(channel: "fresh", hash: 2)

      delete "/admin/solid_cable/messages/trim"

      expect(SolidCable::Message.pluck(:channel)).to contain_exactly("fresh")
    end

    it "is forbidden when trimming is disabled" do
      SolidWebUi::Cable.config.enable_trim = false
      delete "/admin/solid_cable/messages/trim"
      expect(response).to have_http_status(:forbidden)
    ensure
      SolidWebUi::Cable.config.enable_trim = true
    end
  end
end
