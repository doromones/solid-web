# frozen_string_literal: true

module SolidWebUi
  module Ui
    # @label Table
    class TableComponentPreview < ViewComponent::Preview
      # A populated table.
      def default
        render_with_template
      end

      # The empty state.
      def empty
        render(TableComponent.new(headers: %w[Queue Size], empty_message: "No queues with activity."))
      end
    end
  end
end
