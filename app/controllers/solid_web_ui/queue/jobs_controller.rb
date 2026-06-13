# frozen_string_literal: true

module SolidWebUi::Queue
  class JobsController < ApplicationController
    STATUS_SCOPES = {
      "ready" => -> { SolidQueue::Job.where(id: SolidQueue::ReadyExecution.select(:job_id)) },
      "scheduled" => -> { SolidQueue::Job.where(id: SolidQueue::ScheduledExecution.select(:job_id)) },
      "in_progress" => -> { SolidQueue::Job.where(id: SolidQueue::ClaimedExecution.select(:job_id)) },
      "blocked" => -> { SolidQueue::Job.where(id: SolidQueue::BlockedExecution.select(:job_id)) },
      "failed" => -> { SolidQueue::Job.where(id: SolidQueue::FailedExecution.select(:job_id)) },
      "finished" => -> { SolidQueue::Job.where.not(finished_at: nil) }
    }.freeze

    def index
      @status = params[:status].presence_in(STATUS_SCOPES.keys) || "all"
      scope = (STATUS_SCOPES[@status]&.call || SolidQueue::Job.all)
              .includes(:ready_execution, :scheduled_execution, :claimed_execution, :blocked_execution, :failed_execution)
              .order(id: :desc)

      @paginator = SolidWebUi::Paginator.new(scope, page: params[:page], per_page: per_page)
      @jobs = @paginator.records
    end
  end
end
