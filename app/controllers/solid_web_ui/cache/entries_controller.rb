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
      # Per-entry expiry, read from each cache envelope's header (no value
      # deserialization). Numeric epoch = has a TTL, :never = decodable but no
      # TTL, :undecodable = couldn't be read.
      @expiry = @entries.to_h { |entry| [ entry.id, entry_expiry(entry) ] }
    end

    def show
      @decoded = decode_value(@entry.value)
      value = resolved_value(@decoded)
      @value_readable = value != UNREADABLE
      @value_text = value.is_a?(String) ? value : value.inspect if @value_readable
    end

    def new
      @key = ""
      @value = ""
      @expires_at = ""
      @version = ""
    end

    def create
      @key = params[:key].to_s
      @value = params[:value].to_s
      @expires_at = params[:expires_at].to_s
      @version = params[:version].to_s

      if @key.empty?
        return render_new_error("Key can't be blank.")
      elsif SolidCache::Entry.read(@key)
        return render_new_error("An entry with that key already exists.")
      end

      expires_at = parse_expires_at(@expires_at)
      SolidCache::Entry.write(@key, encode_entry(@value, version: @version.presence, expires_at: expires_at))
      redirect_to entries_path, notice: "Entry created."
    rescue InvalidExpiry
      render_new_error("Couldn't parse the expiry time.")
    end

    def edit
      decoded = decode_value(@entry.value)
      value = resolved_value(decoded)
      @value_editable = value.is_a?(String)
      @meta_editable = value != UNREADABLE
      @key = scrub_for_display(@entry.key)
      @expires_at = format_expires_at(decoded)
      @version = (decoded.version if decoded.respond_to?(:version)).to_s

      if @value_editable
        @value = value
      elsif @meta_editable
        @value = value.inspect
        @note = "This entry holds a #{value.class} (not a plain string), so the value is " \
                "read-only — but you can still change its metadata below."
      else
        @value = scrub_for_display(@entry.value)
        @note = "This value couldn't be read as a cache entry (it may use a different cache format " \
                "or reference a class this app can't load), so it can't be edited here."
      end
    end

    def update
      value = resolved_value(decode_value(@entry.value))
      if value == UNREADABLE
        return redirect_to edit_entry_path(@entry), alert: "This entry can't be edited."
      end

      value = params[:value].to_s if value.is_a?(String)
      expires_at = parse_expires_at(params[:expires_at])
      SolidCache::Entry.write(@entry.key, encode_entry(value, version: params[:version].presence, expires_at: expires_at))
      redirect_to entry_path(@entry), notice: "Entry updated."
    rescue InvalidExpiry
      redirect_to edit_entry_path(@entry), alert: "Couldn't parse the expiry time."
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

    InvalidExpiry = Class.new(StandardError)

    # Sentinel for a value that can't be read — either the entry didn't decode, or
    # its envelope decoded but resolving the value raised (a LazyEntry resolves on
    # first access and can fail, e.g. a Marshal value for a class this app can't load).
    UNREADABLE = Object.new.freeze
    private_constant :UNREADABLE

    def set_entry
      @entry = SolidCache::Entry.find(params[:id])
    end

    def render_new_error(message)
      flash.now[:alert] = message
      render :new, status: :unprocessable_entity
    end

    # Resolve a decoded entry's value, returning UNREADABLE if it can't be read.
    def resolved_value(decoded)
      return UNREADABLE unless decoded.respond_to?(:value)

      decoded.value
    rescue StandardError
      UNREADABLE
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

    # Expiry of a single entry for the index: epoch Float, :never, or :undecodable.
    def entry_expiry(entry)
      decoded = decode_value(entry.value)
      return :undecodable unless decoded.respond_to?(:expires_at)

      decoded.expires_at || :never
    end

    # Raw stored bytes -> ActiveSupport::Cache::Entry (or nil if undecodable).
    def decode_value(raw)
      cache_store.send(:deserialize_entry, raw.to_s)
    rescue StandardError
      nil
    end

    # A value + metadata -> serialized cache-entry bytes.
    def encode_entry(value, version:, expires_at:)
      entry = ActiveSupport::Cache::Entry.new(value, version: version, expires_at: expires_at)
      cache_store.send(:serialize_entry, entry)
    end

    def cache_time_zone
      ActiveSupport::TimeZone[SolidWebUi::Cache.config.time_zone] || ActiveSupport::TimeZone["UTC"]
    end

    # Absolute epoch on the decoded entry -> a datetime-local value (YYYY-MM-DDThh:mm:ss)
    # in the dashboard's time zone.
    def format_expires_at(decoded)
      epoch = decoded.expires_at if decoded.respond_to?(:expires_at)
      return "" unless epoch

      Time.at(epoch).in_time_zone(cache_time_zone).strftime("%Y-%m-%dT%H:%M:%S")
    rescue StandardError
      "" # a corrupt/out-of-range epoch shouldn't break the form
    end

    # Form string (in the dashboard's time zone) -> a Time, or nil for "no expiry".
    def parse_expires_at(str)
      return nil if str.blank?

      cache_time_zone.parse(str) || raise(InvalidExpiry)
    rescue ArgumentError, RangeError, TypeError
      raise InvalidExpiry
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
