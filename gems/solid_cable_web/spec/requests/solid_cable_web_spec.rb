# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SolidCableWeb", type: :request do
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
    end
  end

  describe "GET /channels" do
    it "lists channels with their message counts" do
      broadcast(channel: "notifications", hash: 9)

      get "/admin/solid_cable/channels"

      expect(response.body).to include("notifications")
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
      SolidCableWeb.config.enable_trim = false
      delete "/admin/solid_cable/messages/trim"
      expect(response).to have_http_status(:forbidden)
    ensure
      SolidCableWeb.config.enable_trim = true
    end
  end
end
