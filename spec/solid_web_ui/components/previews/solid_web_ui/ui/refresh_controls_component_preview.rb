# frozen_string_literal: true

module SolidWebUi
  module Ui
    # @label Refresh controls
    class RefreshControlsComponentPreview < ViewComponent::Preview
      # @param default_interval number
      def default(default_interval: 10)
        render(RefreshControlsComponent.new(frame_id: "swui-refresh-frame",
                                            default_interval: default_interval))
      end

      # Starting with auto-refresh switched off.
      def off
        render(RefreshControlsComponent.new(frame_id: "swui-refresh-frame", default_interval: 0))
      end
    end
  end
end
