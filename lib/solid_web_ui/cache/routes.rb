# frozen_string_literal: true

SolidWebUi::Cache::Engine.routes.draw do
  root to: "dashboard#index"

  get "entries", to: "entries#index", as: :entries
  get "entries/new", to: "entries#new", as: :new_entry
  post "entries", to: "entries#create"
  delete "entries", to: "entries#clear", as: :clear_entries

  get "entries/:id", to: "entries#show", as: :entry
  get "entries/:id/edit", to: "entries#edit", as: :edit_entry
  patch "entries/:id", to: "entries#update"
  delete "entries/:id", to: "entries#destroy", as: :delete_entry
end
