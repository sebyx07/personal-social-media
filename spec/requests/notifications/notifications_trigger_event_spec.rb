# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /notifications/:id/trigger_event" do
  include_context "logged in"
  include_context "two people"
  let(:notification) { create(:notification_friendship_request, peer: other_peer) }

  before do
    notification
  end

  let(:params) do
    {
      notification: {
        event_name: "accept"
      }
    }
  end

  subject do
    post "/notifications/#{notification.id}/trigger_event", params: params
  end

  it "triggers accept friendship on notification" do
    expect do
      subject
      expect(response).to have_http_status(:ok)
      expect(json[:peer]).to be_present
      notification.reload
    end.to change { notification.seen }.to(true)
       .and change { notification.content }.to({ "status" => "accepted" })
  end
end
