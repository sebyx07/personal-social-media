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
class Notification
  class FriendshipRequest < Notification
    def handle_event(event_name, _)
      if event_name == "accept"
        accept
      elsif event_name == "decline"
        decline
      else
        raise_invalid_event
      end
    end

    private
      def accept
        trigger_relationship(:friend).call!
        self.content = { status: :accepted }
        output
      end

      def decline
        trigger_relationship(:friendship_requested_by_me_blocked).call!
        self.content = { status: :declined }
        output
      end

      def trigger_relationship(relationship)
        PeersService::UpdatePeerRelationship.new(peer, relationship).call!
      end

      def output
        PeerPresenter.new(peer).render_low_data
      end
  end
end
