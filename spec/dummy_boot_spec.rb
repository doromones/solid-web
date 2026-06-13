# frozen_string_literal: true

require "rails_helper"

RSpec.describe "monorepo scaffold" do
  it "boots the dummy Rails application" do
    expect(Rails.application).to be_a(Rails::Application)
    expect(Rails.env.test?).to be(true)
  end

  it "loads the four gems" do
    expect(defined?(SolidWebUi::VERSION)).to be_truthy
    expect(defined?(SolidWebUi::Queue::Engine)).to be_truthy
    expect(defined?(SolidWebUi::Cache::Engine)).to be_truthy
    expect(defined?(SolidWebUi::Cable::Engine)).to be_truthy
  end

  it "has the Solid Queue / Cache / Cable tables in the test database" do
    tables = ActiveRecord::Base.connection.tables
    expect(tables).to include(
      "solid_queue_jobs",
      "solid_queue_failed_executions",
      "solid_queue_processes",
      "solid_cache_entries",
      "solid_cable_messages"
    )
  end
end
