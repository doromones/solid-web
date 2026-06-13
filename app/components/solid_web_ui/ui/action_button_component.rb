# frozen_string_literal: true

module SolidWebUi
  module Ui
    # A button that performs a mutating action through a form (Rails +button_to+):
    # retry/discard a job, pause/resume a queue, clear the cache, trim messages.
    #
    # Always targets the top frame (data-turbo-frame="_top") so the action's
    # redirect/flash escapes the dashboard's refresh turbo-frame. Pass danger: for
    # destructive styling and confirm: for a Turbo confirmation dialog.
    class ActionButtonComponent < ViewComponent::Base
      def initialize(label:, url:, method: :post, danger: false, confirm: nil)
        @label = label
        @url = url
        @method = method
        @danger = danger
        @confirm = confirm
      end

      private

      attr_reader :label, :url

      def http_method = @method

      def css_classes
        [ "swui-btn", (@danger ? "swui-btn--danger" : nil) ].compact.join(" ")
      end

      # button_to applies these to the <form>; the class goes on the <button>.
      def form_options
        data = { turbo_frame: "_top" }
        data[:turbo_confirm] = @confirm if @confirm
        { data: data }
      end
    end
  end
end
