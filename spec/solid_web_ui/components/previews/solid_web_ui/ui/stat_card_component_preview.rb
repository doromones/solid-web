# frozen_string_literal: true

module SolidWebUi
  module Ui
    # @label Stat card
    class StatCardComponentPreview < ViewComponent::Preview
      # @param label text
      # @param value text
      # @param tone select { choices: [neutral, primary, success, warning, danger] }
      def default(label: "Failed", value: "12", tone: :danger)
        render(StatCardComponent.new(label: label, value: value, tone: tone.to_sym))
      end

      # A linked card (clickable).
      def linked
        render(StatCardComponent.new(label: "Jobs", value: 128, tone: :primary, href: "#"))
      end

      # The full set of tones side by side.
      def tones
        render_with_template
      end
    end
  end
end
