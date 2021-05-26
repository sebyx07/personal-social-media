# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PUT /peers/:id" do
  include_context "logged in"
  include_context "two people"

  let(:headers) { { "accept": "application/json" } }
  let(:params) { { peer: { relationship: :friendship_requested_by_me } } }
  let(:url) { "/peers/#{other_peer.id}" }
  let(:current_peer) { Peer.first }
  let(:external_peer) { Peer.last }

  context "friendship_requested_by_me" do
    subject do
      put url, params: params, headers: headers
    end

    it "requests the friendship" do
      subject
      expect(response).to have_http_status(:ok)

      expect(current_peer.status).to match_array(%i(friendship_requested_by_me))
      expect(external_peer.status).to match_array(%i(friendship_requested_by_external))
    end
  end
end
