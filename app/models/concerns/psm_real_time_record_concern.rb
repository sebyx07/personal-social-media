# frozen_string_literal: true

module PsmRealTimeRecordConcern
  extend ActiveSupport::Concern

  included do
    after_commit :propagate_record_realtime_update, on: :update
    after_commit :propagate_record_realtime_destroy, on: :destroy
  end

  private
    def propagate_record_realtime_update
      PsmRealTimeRecord::PropagateRealTime.new(presented_as_json_type, presented_as_json, :update)
    end

    def propagate_record_realtime_destroy
      PsmRealTimeRecord::PropagateRealTime.new(presented_as_json_type, presented_as_json, :destroy)
    end
end
