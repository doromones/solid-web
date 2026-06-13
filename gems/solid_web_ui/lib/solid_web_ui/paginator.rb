# frozen_string_literal: true

module SolidWebUi
  # Tiny offset paginator so the gems don't take a hard dependency on
  # kaminari/pagy. Works with any object responding to #count, #limit and
  # #offset (an ActiveRecord::Relation), or with a precomputed Integer count.
  class Paginator
    attr_reader :page, :per_page, :total_count

    def initialize(scope, page:, per_page: 25)
      @scope = scope
      @per_page = [ per_page.to_i, 1 ].max
      @total_count = scope.is_a?(Integer) ? scope : scope.count
      @page = [ page.to_i, 1 ].max
    end

    def total_pages
      [ (total_count.to_f / per_page).ceil, 1 ].max
    end

    def current_page
      [ [ page, total_pages ].min, 1 ].max
    end

    def offset
      (current_page - 1) * per_page
    end

    def records
      @scope.limit(per_page).offset(offset)
    end

    def first_page?
      current_page <= 1
    end

    def last_page?
      current_page >= total_pages
    end

    def prev_page
      first_page? ? nil : current_page - 1
    end

    def next_page
      last_page? ? nil : current_page + 1
    end
  end
end
