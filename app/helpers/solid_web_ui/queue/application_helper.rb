# frozen_string_literal: true

module SolidWebUi::Queue
  module ApplicationHelper
    def queue_nav(active)
      [
        { label: "Dashboard", href: root_path, active: active == :dashboard },
        { label: "Queues", href: queues_path, active: active == :queues },
        { label: "Jobs", href: jobs_path, active: active == :jobs },
        { label: "Failed", href: failed_executions_path, active: active == :failed },
        { label: "Processes", href: processes_path, active: active == :processes },
        { label: "Recurring", href: recurring_tasks_path, active: active == :recurring }
      ]
    end

    # Status of a job derived from which execution table holds it.
    def job_status(job)
      return :finished if job.finished_at?
      return :failed if job.failed_execution
      return :blocked if job.blocked_execution
      return :in_progress if job.claimed_execution
      return :scheduled if job.scheduled_execution
      return :ready if job.ready_execution

      :unknown
    end

    def queue_latency(queue)
      queue.respond_to?(:human_latency) ? queue.human_latency : queue.latency
    end

    def short_time(time)
      return "—" if time.nil?

      time.in_time_zone(SolidWebUi::Queue.config.time_zone).strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end
