# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notification::FriendshipRequest, type: :request do
  describe "#handle_event" do
    include_context "two people"
    let(:notification) { create(:notification_friendship_request, peer: other_peer) }
    subject do
      notification.handle_event(event_name, nil)
    end

    context "when accept" do
      let(:event_name) { "accept" }

      it "accepts the friendship" do
        expect do
          subject
          other_peer.reload
        end.to change { other_peer.status }.to match([:friend])
      end
    end

    context "when decline" do
      let(:event_name) { "decline" }

      it "accepts the friendship" do
        expect do
          subject
          other_peer.reload
        end.to change { other_peer.status }.to match([:friendship_requested_by_me_blocked])
      end
    end
  end
end
