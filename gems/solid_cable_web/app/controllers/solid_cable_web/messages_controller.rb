# frozen_string_literal: true

module SolidCableWeb
  class MessagesController < ApplicationController
    before_action :ensure_trim_enabled, only: :trim

    def trim
      deleted = trimmable_scope.delete_all
      redirect_to root_path, notice: "Trimmed #{deleted} old message(s)."
    end

    private

    def ensure_trim_enabled
      head :forbidden unless SolidCableWeb.config.enable_trim
    end
  end
end
