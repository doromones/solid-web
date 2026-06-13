# frozen_string_literal: true

module SolidQueueWeb
  class QueuesController < ApplicationController
    before_action :ensure_pause_enabled, only: %i[pause resume]

    def index
      @queues = SolidQueue::Queue.all
    end

    def pause
      SolidQueue::Queue.find_by_name(params[:name]).pause
      redirect_to queues_path, notice: "Queue #{params[:name]} paused."
    end

    def resume
      SolidQueue::Queue.find_by_name(params[:name]).resume
      redirect_to queues_path, notice: "Queue #{params[:name]} resumed."
    end

    private

    def ensure_pause_enabled
      head :forbidden unless SolidQueueWeb.config.enable_pause
    end
  end
end
