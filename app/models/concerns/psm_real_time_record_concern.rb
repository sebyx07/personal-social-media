# frozen_string_literal: true

module PsmRealTimeRecordConcern
  extend ActiveSupport::Concern

  included do
    after_commit :propagate_record_realtime_update, on: :update, if: -> { can_propagate_realtime? }
    after_commit :propagate_record_realtime_destroy, on: :destroy, if: -> { can_propagate_realtime? }
  end

  private
    def propagate_record_realtime_update
      PsmRealTimeRecord::PropagateRealTime.new(real_time_record, :update).call
    end

    def propagate_record_realtime_destroy
      PsmRealTimeRecord::PropagateRealTime.new(real_time_record, :destroy).call
    end
end
