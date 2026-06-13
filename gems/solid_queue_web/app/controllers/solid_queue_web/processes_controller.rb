# frozen_string_literal: true

module SolidQueueWeb
  class ProcessesController < ApplicationController
    def index
      @processes = SolidQueue::Process.order(:kind, :name)
    end
  end
end
