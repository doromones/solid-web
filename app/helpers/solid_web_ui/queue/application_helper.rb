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

    # Best available execution time for a job. Solid Queue does not persist a job's
    # start time once it finishes (the claimed_execution row is deleted on finish),
    # so:
    #   - finished job  → finished_at - created_at (total time in the system)
    #   - claimed job   → now - claimed_execution.created_at (live run time)
    #   - anything else → nil (no meaningful duration yet)
    def job_duration(job)
      if job.finished_at?
        human_duration(job.finished_at - job.created_at)
      elsif job.claimed_execution
        human_duration(Time.current - job.claimed_execution.created_at)
      end
    end

    # Compact, sub-minute-precise duration: "1.2s", "3m 04s", "2h 01m".
    def human_duration(seconds)
      return "—" if seconds.nil?

      seconds = seconds.to_f
      return format("%.1fs", seconds) if seconds < 60

      if seconds < 3600
        format("%dm %02ds", seconds / 60, seconds % 60)
      else
        format("%dh %02dm", seconds / 3600, (seconds % 3600) / 60)
      end
    end

    def short_time(time)
      return "—" if time.nil?

      time.in_time_zone(SolidWebUi::Queue.config.time_zone).strftime("%Y-%m-%d %H:%M:%S")
    end
  end
end
