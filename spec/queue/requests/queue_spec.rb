# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SolidWebUi::Queue dashboard", type: :request do
  # A freshly created Job auto-dispatches to a ReadyExecution (after_create), so
  # create_job yields a job already in the "ready" state.
  def create_job(queue: "default", **attrs)
    SolidQueue::Job.create!(queue_name: queue, class_name: "DemoJob",
                            arguments: { "executions" => 0, "exception_executions" => {} }, **attrs)
  end

  def make_failed(job, message: "kaboom")
    job.ready_execution&.destroy
    SolidQueue::FailedExecution.create!(job: job, error: { "exception_class" => "RuntimeError", "message" => message })
  end

  describe "GET / (dashboard)" do
    it "renders status counts inside the shared layout" do
      create_job # ready
      make_failed(create_job)

      get "/admin/solid_queue"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("solid-web-ui")          # shared layout wrapper
      expect(response.body).to include("solid_web_ui")          # bundled stylesheet link
      expect(response.body).to include("Ready", "Failed")
    end
  end

  describe "GET /jobs" do
    it "filters by status" do
      make_failed(create_job(queue: "alpha"))
      create_job(queue: "beta") # ready

      get "/admin/solid_queue/jobs", params: { status: "failed" }

      expect(response.body).to include("alpha")
      expect(response.body).not_to include("beta")
    end
  end

  describe "queues" do
    it "lists queues and pauses/resumes them" do
      create_job(queue: "mailers") # ready → queue appears

      get "/admin/solid_queue/queues"
      expect(response.body).to include("mailers")

      post "/admin/solid_queue/queues/mailers/pause"
      expect(SolidQueue::Pause.where(queue_name: "mailers")).to exist

      post "/admin/solid_queue/queues/mailers/resume"
      expect(SolidQueue::Pause.where(queue_name: "mailers")).not_to exist
    end

    it "forbids pausing when the action is disabled" do
      SolidWebUi::Queue.config.enable_pause = false
      post "/admin/solid_queue/queues/x/pause"
      expect(response).to have_http_status(:forbidden)
    ensure
      SolidWebUi::Queue.config.enable_pause = true
    end
  end

  describe "failed executions" do
    it "retries a failed job" do
      failed = make_failed(create_job)

      post "/admin/solid_queue/failed/#{failed.id}/retry"

      expect(SolidQueue::FailedExecution.exists?(failed.id)).to be(false)
      expect(SolidQueue::ReadyExecution.where(job_id: failed.job_id)).to exist
    end

    it "discards a failed job" do
      failed = make_failed(create_job)
      job_id = failed.job_id

      delete "/admin/solid_queue/failed/#{failed.id}"

      expect(SolidQueue::Job.exists?(job_id)).to be(false)
    end

    it "forbids retry when disabled" do
      failed = make_failed(create_job)
      SolidWebUi::Queue.config.enable_retry = false

      post "/admin/solid_queue/failed/#{failed.id}/retry"
      expect(response).to have_http_status(:forbidden)
    ensure
      SolidWebUi::Queue.config.enable_retry = true
    end
  end

  describe "processes and recurring tasks" do
    it "lists processes" do
      SolidQueue::Process.create!(kind: "Worker", name: "worker-1", pid: 42, hostname: "host-a",
                                  last_heartbeat_at: Time.current)
      get "/admin/solid_queue/processes"
      expect(response.body).to include("worker-1", "host-a")
    end

    it "lists recurring tasks" do
      SolidQueue::RecurringTask.create!(key: "cleanup", schedule: "0 0 * * *", command: "CleanupJob.run", static: true)
      get "/admin/solid_queue/recurring_tasks"
      expect(response.body).to include("cleanup", "CleanupJob")
    end
  end
end
