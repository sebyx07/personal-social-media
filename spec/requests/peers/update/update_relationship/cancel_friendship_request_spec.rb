# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PUT /peers/:id" do
  include_context "logged in"
  include_context "two people"

  let(:headers) { { "accept": "application/json" } }
  let(:params) { { peer: { relationship: :cancel_friendship } } }
  let(:url) { "/peers/#{other_peer.id}" }

  context "cancel_friendship" do
    before do
      setup_my_peer(statuses: :friendship_requested_by_external) # as in other peers eyes
      setup_other_peer(statuses: :friendship_requested_by_me)
    end

    subject do
      put url, params: params, headers: headers
      other_peer.reload
      my_peer.reload
    end

    it "cancels the friendship, from other_peer peers perspective" do
      subject
      expect(response).to have_http_status(:ok)

      expect(reverse_my_peer.status).to match_array(%i())
      expect(reverse_my_peer.status).to match_array(%i())
    end
  end
end
