# frozen_string_literal: true

module SolidQueueWeb
  class RecurringTasksController < ApplicationController
    def index
      @tasks = SolidQueue::RecurringTask.order(:key)
    end
  end
end
