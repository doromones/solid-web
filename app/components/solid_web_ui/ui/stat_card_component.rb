# frozen_string_literal: true

module SolidWebUi
  module Ui
    # A single dashboard metric: a label and a (usually numeric) value, optionally
    # toned (neutral/primary/success/warning/danger) and linkable.
    class StatCardComponent < ViewComponent::Base
      def initialize(label:, value:, tone: :neutral, href: nil)
        @label = label
        @value = value
        @tone = tone
        @href = href
      end

      private

      attr_reader :label, :value, :href

      def css_classes
        [ "swui-card", "swui-card--#{@tone}" ].join(" ")
      end
    end
  end
end
