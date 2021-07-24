# frozen_string_literal: true

class RealTimeRecordsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "psm_real_time_updates"
  end
end
