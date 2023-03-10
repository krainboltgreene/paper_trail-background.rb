require "paper_trail/record_trail"

module PaperTrail
  require_relative "background/version"
  require_relative "background/job"

  module Background
    # @api private
    # @return - The created version object, so that plugins can use it, e.g.
    # paper_trail-association_tracking
    def record_create
      return unless enabled?

      event = PaperTrail::Events::Create.new(@record, true)

      # Merge data from `Event` with data from PT-AT. We no longer use
      # `data_for_create` but PT-AT still does.
      data = event.data.merge(data_for_create)

      trigger_write(@record, data, :create)
    end

    # `recording_order` is "after" or "before". See ModelConfig#on_destroy.
    #
    # @api private
    # @return - The created version object, so that plugins can use it, e.g.
    # paper_trail-association_tracking
    def record_destroy(recording_order)
      return unless enabled?
      return if @record.new_record?

      in_after_callback = recording_order == "after"

      event = PaperTrail::Events::Destroy.new(@record, in_after_callback)

      # Merge data from `Event` with data from PT-AT. We no longer use
      # `data_for_destroy` but PT-AT still does.
      data = event.data.merge(data_for_destroy)

      trigger_write(@record, data, :destroy)
    end

    # @api private
    # @return - The created version object, so that plugins can use it, e.g.
    # paper_trail-association_tracking
    def record_update(force:, in_after_callback:, is_touch:)
      return unless enabled?

      event = PaperTrail::Events::Update.new(@record, in_after_callback, is_touch, nil)

      return unless force || event.changed_notably?

      # Merge data from `Event` with data from PT-AT. We no longer use
      # `data_for_update_columns` but PT-AT still does.
      data = event.data.merge(data_for_update_columns)

      trigger_write(@record, data, :update)
    end

    # @api private
    # @return - The created version object, so that plugins can use it, e.g.
    # paper_trail-association_tracking
    def record_update_columns(changes)
      return unless enabled?

      event = Events::Update.new(@record, false, false, changes)

      return unless force || event.changed_notably?

      # Merge data from `Event` with data from PT-AT. We no longer use
      # `data_for_update_columns` but PT-AT still does.
      data = event.data.merge(data_for_update_columns)

      trigger_write(@record, data, :update)
    end

    private def trigger_write(record, data, event)
      version_class = record.class.paper_trail.version_class.name

      ActiveRecord::Base.after_transaction do
        VersionJob.perform_later(
          version_class,
          data,
          event
        )
      end
    end
  end
end

PaperTrail::RecordTrail.prepend(PaperTrail::Background)
