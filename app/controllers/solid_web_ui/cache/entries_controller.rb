# frozen_string_literal: true

module SolidWebUi::Cache
  class EntriesController < ApplicationController
    before_action :ensure_clear_enabled,  only: :clear
    before_action :ensure_create_enabled, only: %i[new create]
    before_action :ensure_edit_enabled,   only: %i[edit update]
    before_action :ensure_delete_enabled, only: :destroy
    before_action :set_entry, only: %i[show edit update destroy]

    def index
      scope = SolidCache::Entry.order(id: :desc)
      @paginator = SolidWebUi::Paginator.new(scope, page: params[:page], per_page: per_page)
      @entries = @paginator.records
    end

    def show; end

    def new
      @key = ""
      @value = ""
    end

    def create
      @key = params[:key].to_s
      @value = params[:value].to_s

      if @key.empty?
        flash.now[:alert] = "Key can't be blank."
        return render :new, status: :unprocessable_entity
      end
      if SolidCache::Entry.read(@key)
        flash.now[:alert] = "An entry with that key already exists."
        return render :new, status: :unprocessable_entity
      end

      SolidCache::Entry.write(@key, @value)
      redirect_to entries_path, notice: "Entry created."
    end

    def edit
      raw = @entry.value.to_s
      @binary = !raw.dup.force_encoding("UTF-8").valid_encoding?
      @key = scrub_for_display(@entry.key)
      @value = scrub_for_display(raw)
    end

    def update
      @value = params[:value].to_s
      SolidCache::Entry.write(@entry.key, @value)
      redirect_to entry_path(@entry), notice: "Entry updated."
    end

    def destroy
      @entry.destroy
      redirect_to entries_path, notice: "Entry deleted."
    end

    def clear
      SolidCache::Entry.delete_all
      redirect_to root_path, notice: "Cache cleared."
    end

    private

    def set_entry
      @entry = SolidCache::Entry.find(params[:id])
    end

    # Cache keys/values are binary; force to UTF-8 and replace any invalid bytes
    # so they can be rendered in a form field without raising.
    def scrub_for_display(bytes)
      bytes.to_s.dup.force_encoding("UTF-8").scrub("?")
    end

    def ensure_clear_enabled
      head :forbidden unless SolidWebUi::Cache.config.enable_clear
    end

    def ensure_create_enabled
      head :forbidden unless SolidWebUi::Cache.config.enable_create
    end

    def ensure_edit_enabled
      head :forbidden unless SolidWebUi::Cache.config.enable_edit
    end

    def ensure_delete_enabled
      head :forbidden unless SolidWebUi::Cache.config.enable_delete
    end
  end
end
