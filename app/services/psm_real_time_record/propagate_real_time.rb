# frozen_string_literal: true

module PsmRealTimeRecord
  class PropagateRealTime
    class UnknownAction < StandardError; end
    attr_reader :presented_as_json, :presented_as_json_type, :action
    def initialize(presented_as_json_type, presented_as_json, action)
      @presented_as_json_type = presented_as_json_type
      @presented_as_json = presented_as_json
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

      ActionCable.server.broadcast("psm_real_time", message)
    end

    private
      def update_message
        { action: action, type: presented_as_json_type, record: presented_as_json }
      end

      def destroy_message
        { action: action, type: presented_as_json_type, record_id: presented_as_json[:id] }
      end
  end
end
