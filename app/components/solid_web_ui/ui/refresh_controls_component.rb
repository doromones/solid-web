# frozen_string_literal: true

module SolidWebUi
  module Ui
    # Live auto-refresh controls for a dashboard page: a frequency <select>, a
    # countdown to the next refresh and a manual "refresh now" button. The actual
    # polling is driven by the bundled vanilla JS (app/assets/javascripts/
    # solid_web_ui.js), which reads the data-* attributes emitted here and reloads
    # the turbo-frame named by +frame_id+. Rendering is pure markup, so the panel
    # works whether or not Turbo is on the page (JS falls back to fetch+replace).
    class RefreshControlsComponent < ViewComponent::Base
      STORAGE_KEY = "swui:refresh-interval"

      def initialize(frame_id:, default_interval: nil, intervals: nil)
        @frame_id = frame_id
        @default_interval = (default_interval || SolidWebUi.config.refresh_interval).to_i
        @intervals = Array(intervals || SolidWebUi.config.refresh_intervals).map(&:to_i)
      end

      private

      attr_reader :frame_id, :default_interval, :intervals

      def option_label(seconds)
        seconds.zero? ? "Off" : "#{seconds}s"
      end
    end
  end
end
