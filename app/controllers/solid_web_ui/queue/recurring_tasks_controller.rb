# frozen_string_literal: true

module SolidWebUi::Queue
  class RecurringTasksController < ApplicationController
    def index
      @tasks = SolidQueue::RecurringTask.order(:key)
    end
  end
end
