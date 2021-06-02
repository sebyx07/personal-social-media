# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PUT /peers/:id" do
  include_context "logged in"
  include_context "two people"

  let(:headers) { { "accept": "application/json" } }
  let(:params) { { peer: { relationship: :friend } } }
  let(:url) { "/peers/#{other_peer.id}" }

  context "friend" do
    before do
      setup_my_peer(statuses: :friendship_requested_by_me)
      setup_other_peer(statuses: :friendship_requested_by_external)
    end

    subject do
      put url, params: params, headers: headers
      other_peer.reload
      my_peer.reload
    end

    it "accepts the friendship" do
      subject
      expect(response).to have_http_status(:ok)

      expect(reverse_my_peer.status).to match_array(%i(friend))
      expect(reverse_my_peer.status).to match_array(%i(friend))
    end
  end
end
