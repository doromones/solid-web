# frozen_string_literal: true

module SolidWebUi::Queue
  class ProcessesController < ApplicationController
    def index
      @processes = SolidQueue::Process.order(:kind, :name)
    end
  end
end
