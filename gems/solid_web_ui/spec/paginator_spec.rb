# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolidWebUi::Paginator do
  # A lightweight stand-in for an ActiveRecord::Relation.
  let(:scope) do
    Class.new do
      attr_reader :limit_value, :offset_value
      def count = 95
      def limit(n)
        @limit_value = n
        self
      end

      def offset(n)
        @offset_value = n
        self
      end
    end.new
  end

  it "computes total pages from count and per_page" do
    paginator = described_class.new(scope, page: 1, per_page: 25)
    expect(paginator.total_pages).to eq(4)
    expect(paginator.total_count).to eq(95)
  end

  it "applies limit and offset to the scope" do
    paginator = described_class.new(scope, page: 3, per_page: 25)
    paginator.records
    expect(scope.limit_value).to eq(25)
    expect(scope.offset_value).to eq(50)
  end

  it "clamps the page to the valid range" do
    expect(described_class.new(scope, page: 0, per_page: 25).current_page).to eq(1)
    expect(described_class.new(scope, page: 999, per_page: 25).current_page).to eq(4)
  end

  it "reports first/last page boundaries" do
    expect(described_class.new(scope, page: 1, per_page: 25)).to be_first_page
    expect(described_class.new(scope, page: 4, per_page: 25)).to be_last_page
  end

  it "exposes next/prev page numbers, nil at the edges" do
    middle = described_class.new(scope, page: 2, per_page: 25)
    expect(middle.prev_page).to eq(1)
    expect(middle.next_page).to eq(3)
    expect(described_class.new(scope, page: 1, per_page: 25).prev_page).to be_nil
    expect(described_class.new(scope, page: 4, per_page: 25).next_page).to be_nil
  end

  it "accepts an integer count instead of a scope for cheap pagination" do
    paginator = described_class.new(10, page: 1, per_page: 25)
    expect(paginator.total_pages).to eq(1)
  end
end
