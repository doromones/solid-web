# frozen_string_literal: true

require "rails_helper"

RSpec.describe "SolidWebUi configuration" do
  it "exposes theming settings with defaults" do
    expect(SolidWebUi.config.color_scheme).to eq("auto")
    expect(SolidWebUi.config.stylesheet).to be(true)
    expect(SolidWebUi.config.extra_stylesheets).to eq([])
    expect(SolidWebUi.config.theme).to eq({})
  end

  describe SolidWebUi::Configurable do
    let(:host_module) do
      Module.new do
        def self.name = "DemoWeb"
        extend SolidWebUi::Configurable
      end
    end

    it "adds the shared base settings to an extending module" do
      expect(host_module.config.base_controller_class).to eq("ActionController::Base")
      expect(host_module.config.per_page).to eq(25)
      expect(host_module.config.time_zone).to eq("UTC")
    end

    it "lets the host override settings" do
      host_module.config.base_controller_class = "Admin::BaseController"
      host_module.config.per_page = 50

      expect(host_module.config.base_controller_class).to eq("Admin::BaseController")
      expect(host_module.config.per_page).to eq(50)
    end
  end

  describe ".resolve_base_controller" do
    it "constantizes the configured controller class name" do
      expect(SolidWebUi.resolve_base_controller("ActionController::Base")).to eq(ActionController::Base)
    end
  end
end
