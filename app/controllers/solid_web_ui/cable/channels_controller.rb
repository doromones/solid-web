# frozen_string_literal: true

module SolidWebUi::Cable
  class ChannelsController < ApplicationController
    def index
      counts = SolidCable::Message.group(:channel, :channel_hash).count
      last_seen = SolidCable::Message.group(:channel).maximum(:created_at)
      @channels = counts
                  .map { |(channel, hash), count| { name: channel, hash: hash, count: count, last: last_seen[channel] } }
                  .sort_by { |row| -row[:count] }
    end

    def show
      scope = SolidCable::Message.where(channel_hash: params[:channel_hash])
      @name = scope.limit(1).pick(:channel)
      raise ActiveRecord::RecordNotFound if @name.nil?

      @channel_hash = params[:channel_hash]
      @count = scope.count
      @first = scope.minimum(:created_at)
      @last = scope.maximum(:created_at)

      @paginator = SolidWebUi::Paginator.new(scope.order(id: :desc), page: params[:page], per_page: per_page)
      @messages = @paginator.records
    end
  end
end
