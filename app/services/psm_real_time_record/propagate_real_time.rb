# frozen_string_literal: true

module PsmRealTimeRecord
  class PropagateRealTime
    class UnknownAction < StandardError; end
    attr_reader :real_time_record, :action
    def initialize(real_time_record, action)
      @real_time_record = real_time_record
      @action = action
    end

    def call
      message = if action == :update
        update_message
      elsif action == :destroy
        destroy_message
      else
        raise UnknownAction, "unknown action #{action}"
      end

      ActionCable.server.broadcast("psm_real_time_updates", message)
    end

    private
      def update_message
        { action: action, type: real_time_record.type, record: real_time_record.json, virtual_id: real_time_record.virtual_id }
      end

      def destroy_message
        { action: action, type: real_time_record, record_id: real_time_record.json[:id], virtual_id: real_time_record.virtual_id }
      end
  end
end
