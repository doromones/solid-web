# frozen_string_literal: true

module SolidQueueWeb
  class FailedExecutionsController < ApplicationController
    before_action :ensure_retry_enabled, only: :retry
    before_action :ensure_discard_enabled, only: :discard

    def index
      scope = SolidQueue::FailedExecution.includes(:job).order(id: :desc)
      @paginator = SolidWebUi::Paginator.new(scope, page: params[:page], per_page: per_page)
      @failed = @paginator.records
    end

    def retry
      SolidQueue::FailedExecution.find(params[:id]).retry
      redirect_to failed_executions_path, notice: "Job re-enqueued."
    end

    def discard
      SolidQueue::FailedExecution.find(params[:id]).job.destroy
      redirect_to failed_executions_path, notice: "Failed job discarded."
    end

    private

    def ensure_retry_enabled
      head :forbidden unless SolidQueueWeb.config.enable_retry
    end

    def ensure_discard_enabled
      head :forbidden unless SolidQueueWeb.config.enable_discard
    end
  end
end
