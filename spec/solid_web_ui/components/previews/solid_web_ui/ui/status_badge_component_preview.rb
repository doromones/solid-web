# frozen_string_literal: true

module SolidWebUi
  module Ui
    # @label Status badge
    class StatusBadgeComponentPreview < ViewComponent::Preview
      # @param label text
      # @param status select { choices: [ready, scheduled, in_progress, finished, failed, blocked, paused] }
      def default(label: "failed", status: :failed)
        render(StatusBadgeComponent.new(label: label, status: status.to_sym))
      end

      # Every status mapped to its tone.
      def all
        render_with_template
      end
    end
  end
end
