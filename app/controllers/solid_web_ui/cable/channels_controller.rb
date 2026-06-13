# frozen_string_literal: true

module SolidWebUi::Cable
  class ChannelsController < ApplicationController
    def index
      counts = SolidCable::Message.group(:channel).count
      last_seen = SolidCable::Message.group(:channel).maximum(:created_at)
      @channels = counts
                  .map { |channel, count| { name: channel, count: count, last: last_seen[channel] } }
                  .sort_by { |row| -row[:count] }
    end
  end
end
