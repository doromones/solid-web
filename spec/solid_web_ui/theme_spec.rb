# frozen_string_literal: true

require "rails_helper"

RSpec.describe SolidWebUi::Theme do
  describe ".css_vars" do
    it "emits the full token contract with default values" do
      css = described_class.css_vars

      expect(css).to include("--swui-color-primary:")
      expect(css).to include("--swui-color-bg:")
      expect(css).to include("--swui-radius:")
      expect(css).to include("--swui-font:")
    end

    it "lets defaults inherit common host variables via fallback" do
      css = described_class.css_vars

      expect(css).to include("var(--color-primary,")
    end

    it "overrides tokens from a theme hash" do
      css = described_class.css_vars(color_primary: "#7c3aed")

      expect(css).to include("--swui-color-primary: #7c3aed;")
    end

    it "ignores unknown token keys" do
      css = described_class.css_vars(bogus_token: "x")

      expect(css).not_to include("bogus")
    end

    it "sanitizes values to prevent breaking out of the <style> block" do
      css = described_class.css_vars(color_primary: "red; } body { display:none")

      expect(css).not_to include("}")
      expect(css).not_to include("body")
    end
  end

  describe ".dark_css_vars" do
    it "returns dark-scheme overrides" do
      expect(described_class.dark_css_vars).to include("--swui-color-bg:")
    end
  end
end
