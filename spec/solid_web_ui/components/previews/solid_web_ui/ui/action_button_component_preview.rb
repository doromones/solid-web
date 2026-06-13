# frozen_string_literal: true

module SolidWebUi
  module Ui
    # @label Action button
    class ActionButtonComponentPreview < ViewComponent::Preview
      # @param label text
      # @param danger toggle
      def default(label: "Retry", danger: false)
        render(ActionButtonComponent.new(label: label, url: "#", danger: danger))
      end

      # A destructive action: danger styling + a confirmation dialog.
      def danger_with_confirm
        render(ActionButtonComponent.new(label: "Discard", url: "#", method: :delete,
                                         danger: true, confirm: "Discard permanently?"))
      end
    end
  end
end
