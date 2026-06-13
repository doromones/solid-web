# frozen_string_literal: true

Rails.application.routes.draw do
  mount SolidWebUi::Queue::Engine => "/admin/solid_queue"
  mount SolidWebUi::Cache::Engine => "/admin/solid_cache"
  mount SolidWebUi::Cable::Engine => "/admin/solid_cable"

  mount Lookbook::Engine, at: "/lookbook" if defined?(Lookbook::Engine)
end
