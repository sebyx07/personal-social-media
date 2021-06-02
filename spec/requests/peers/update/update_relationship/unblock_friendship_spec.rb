# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PUT /peers/:id" do
  include_context "logged in"
  include_context "two people"

  let(:headers) { { "accept": "application/json" } }
  let(:params) { { peer: { relationship: :unblock } } }
  let(:url) { "/peers/#{other_peer.id}" }

  context "unblock" do
    before do
      setup_my_peer(statuses: %i(friend full_block_by_external)) # as in other peers eyes
      setup_other_peer(statuses: %i(friend full_block_by_me))
    end

    subject do
      put url, params: params, headers: headers
      my_peer.reload
      other_peer.reload
    end

    it "unblocks the friendship" do
      subject
      expect(response).to have_http_status(:ok)

      expect(reverse_my_peer.status).to match_array(%i(friend))
      expect(other_peer.status).to match_array(%i(friend))
    end
  end
end
