# frozen_string_literal: true

module SolidWebUi
  module Ui
    # A small pill conveying a record's status. Maps a domain status symbol to one
    # of the shared tone classes; unknown statuses degrade to a neutral pill.
    class StatusBadgeComponent < ViewComponent::Base
      TONES = {
        ready: :info,
        scheduled: :info,
        in_progress: :info,
        claimed: :info,
        finished: :success,
        succeeded: :success,
        failed: :danger,
        blocked: :warning,
        paused: :warning,
        stale: :warning
      }.freeze

      def initialize(label:, status: nil)
        @label = label
        @status = status
      end

      def call
        content_tag(:span, @label, class: "swui-badge swui-badge--#{tone}")
      end

      private

      def tone
        TONES.fetch(@status&.to_sym, :neutral)
      end
    end
  end
end
