# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ViewComponent previews", type: :component do
  our_previews = ViewComponent::Preview.all.select { |p| p.name.start_with?("SolidWebUi::Ui::") }

  it "discovers the component previews" do
    expect(our_previews.map(&:name)).to include(
      "SolidWebUi::Ui::StatCardComponentPreview",
      "SolidWebUi::Ui::TableComponentPreview",
      "SolidWebUi::Ui::PageComponentPreview"
    )
  end

  our_previews.each do |preview|
    preview.examples.each do |example|
      it "renders #{preview.name}##{example}" do
        expect(render_preview(example.to_sym, from: preview)).to be_present
      end
    end
  end
end
