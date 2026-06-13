# frozen_string_literal: true

module SolidQueueWeb
  class DashboardController < ApplicationController
    def index
      @counts = {
        ready: SolidQueue::ReadyExecution.count,
        scheduled: SolidQueue::ScheduledExecution.count,
        in_progress: SolidQueue::ClaimedExecution.count,
        blocked: SolidQueue::BlockedExecution.count,
        failed: SolidQueue::FailedExecution.count,
        finished: SolidQueue::Job.where.not(finished_at: nil).count
      }
      @queue_count = SolidQueue::Queue.all.size
      @process_count = SolidQueue::Process.count
    end
  end
end
