# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PUT /peers/:id" do
  include_context "logged in"
  include_context "two people"

  let(:headers) { { "accept": "application/json" } }
  let(:params) { { peer: { relationship: :full_block_by_me } } }
  let(:url) { "/peers/#{other_peer.id}" }

  context "full_block_by_me" do
    before do
      setup_my_peer(statuses: :friend)
      setup_other_peer(statuses: :friend)
    end

    subject do
      put url, params: params, headers: headers
      other_peer.reload
      my_peer.reload
    end

    it "blocks the friendship, from other_peer peers perspective" do
      subject
      expect(response).to have_http_status(:ok)

      expect(reverse_my_peer.status).to include(:full_block_by_me)
      expect(reverse_other_peer.status).to include(:full_block_by_external)
    end
  end
end
