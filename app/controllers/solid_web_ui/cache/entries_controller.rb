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

    def show
      @decoded = decode_value(@entry.value)
    end

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

      SolidCache::Entry.write(@key, encode_value(@value))
      redirect_to entries_path, notice: "Entry created."
    end

    def edit
      decoded = decode_value(@entry.value)
      @editable = editable_value?(decoded)
      @key = scrub_for_display(@entry.key)

      if @editable
        @value = decoded.value
      elsif decoded.respond_to?(:value)
        @value = decoded.value.inspect
        @note = "This entry holds a #{decoded.value.class} (not a plain string), so it can't be " \
                "edited as text here. Delete it, or change it from your application."
      else
        @value = scrub_for_display(@entry.value)
        @note = "This value couldn't be decoded as a cache entry (it may use a different cache " \
                "format), so it can't be safely edited here."
      end
    end

    def update
      decoded = decode_value(@entry.value)
      unless editable_value?(decoded)
        return redirect_to edit_entry_path(@entry), alert: "This entry can't be edited as text."
      end

      SolidCache::Entry.write(@entry.key, encode_value(params[:value].to_s, like: decoded))
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

    # Only plain-string cache values can round-trip through a textarea.
    def editable_value?(decoded)
      decoded.respond_to?(:value) && decoded.value.is_a?(String)
    end

    # The cache store whose coder matches how these entries were written. Prefer the
    # host's Rails.cache when it is the Solid Cache store (exact format match), and
    # fall back to a default Solid Cache store otherwise.
    def cache_store
      @cache_store ||=
        if defined?(SolidCache::Store) && Rails.cache.is_a?(SolidCache::Store)
          Rails.cache
        else
          ActiveSupport::Cache.lookup_store(:solid_cache_store)
        end
    end

    # Raw stored bytes -> ActiveSupport::Cache::Entry (or nil if undecodable).
    def decode_value(raw)
      cache_store.send(:deserialize_entry, raw.to_s)
    rescue StandardError
      nil
    end

    # A logical string value -> serialized cache-entry bytes, preserving the version
    # and remaining TTL of the entry it replaces when present.
    def encode_value(string, like: nil)
      options = {}
      options[:version] = like.version if like.respond_to?(:version) && like.version
      if like.respond_to?(:expires_at) && like.expires_at
        remaining = like.expires_at - Time.now.to_f
        options[:expires_in] = remaining if remaining.positive?
      end

      cache_store.send(:serialize_entry, ActiveSupport::Cache::Entry.new(string, **options))
    end

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
