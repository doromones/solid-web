# frozen_string_literal: true

module SolidWebUi
  module Ui
    # A styled data table. Pass column `headers`; render the body rows as the
    # component's content (a block of <tr> rows). Shows an empty state when no
    # rows are given.
    class TableComponent < ViewComponent::Base
      def initialize(headers:, empty_message: "Nothing to show.")
        @headers = headers
        @empty_message = empty_message
      end

      private

      attr_reader :headers, :empty_message
    end
  end
end
