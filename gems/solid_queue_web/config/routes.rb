# frozen_string_literal: true

SolidQueueWeb::Engine.routes.draw do
  root to: "dashboard#index"

  get "queues", to: "queues#index", as: :queues
  post "queues/:name/pause", to: "queues#pause", as: :pause_queue, constraints: { name: %r{[^/]+} }
  post "queues/:name/resume", to: "queues#resume", as: :resume_queue, constraints: { name: %r{[^/]+} }

  get "jobs", to: "jobs#index", as: :jobs

  get "failed", to: "failed_executions#index", as: :failed_executions
  post "failed/:id/retry", to: "failed_executions#retry", as: :retry_failed_execution
  delete "failed/:id", to: "failed_executions#discard", as: :failed_execution

  get "processes", to: "processes#index", as: :processes
  get "recurring_tasks", to: "recurring_tasks#index", as: :recurring_tasks
end
