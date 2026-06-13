# frozen_string_literal: true

module SolidCableWeb
  class DashboardController < ApplicationController
    def index
      @total = SolidCable::Message.count
      @channel_count = SolidCable::Message.distinct.count(:channel)
      @trimmable = trimmable_scope.count
      @last_hour = SolidCable::Message.where(created_at: 1.hour.ago..).count
      @top_channels = SolidCable::Message.group(:channel).count.max_by(10) { |_channel, count| count }
    end
  end
end
