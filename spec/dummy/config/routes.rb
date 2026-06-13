# frozen_string_literal: true

Rails.application.routes.draw do
  mount SolidQueueWeb::Engine => "/admin/solid_queue"
  mount SolidCacheWeb::Engine => "/admin/solid_cache"
  mount SolidCableWeb::Engine => "/admin/solid_cable"

  mount Lookbook::Engine, at: "/lookbook" if defined?(Lookbook::Engine)
end
