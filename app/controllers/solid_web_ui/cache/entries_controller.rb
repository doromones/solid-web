# frozen_string_literal: true

module SolidWebUi::Cache
  class EntriesController < ApplicationController
    before_action :ensure_clear_enabled, only: :clear

    def index
      scope = SolidCache::Entry.order(id: :desc)
      @paginator = SolidWebUi::Paginator.new(scope, page: params[:page], per_page: per_page)
      @entries = @paginator.records
    end

    def clear
      SolidCache::Entry.delete_all
      redirect_to root_path, notice: "Cache cleared."
    end

    private

    def ensure_clear_enabled
      head :forbidden unless SolidWebUi::Cache.config.enable_clear
    end
  end
end
