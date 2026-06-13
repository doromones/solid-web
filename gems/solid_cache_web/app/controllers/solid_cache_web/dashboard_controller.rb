# frozen_string_literal: true

module SolidCacheWeb
  class DashboardController < ApplicationController
    def index
      @count = SolidCache::Entry.count
      @total_bytes = SolidCache::Entry.sum(:byte_size)
      @avg_bytes = SolidCache::Entry.average(:byte_size).to_f.round
      @oldest = SolidCache::Entry.minimum(:created_at)
      @newest = SolidCache::Entry.maximum(:created_at)
    end
  end
end
