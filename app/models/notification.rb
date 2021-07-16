# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id           :bigint           not null, primary key
#  content      :jsonb            not null
#  seen         :boolean          default(FALSE), not null
#  subject_type :string
#  type         :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  peer_id      :bigint           not null
#  subject_id   :bigint
#
# Indexes
#
#  index_notifications_on_peer_id  (peer_id)
#  index_notifications_on_subject  (subject_type,subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (peer_id => peers.id)
#
class Notification < ApplicationRecord
  class InvalidEvent < StandardError; end
  belongs_to :peer
  belongs_to :subject, polymorphic: true, optional: true

  def raise_invalid_event
    raise InvalidEvent, "invalid event"
  end

  def handle_event_wrapper(event_name, event_value)
    output = nil

    Notification.transaction do
      output = handle_event(event_name, event_value)
      self.seen = true
      save!
    end
    output
  end
end
