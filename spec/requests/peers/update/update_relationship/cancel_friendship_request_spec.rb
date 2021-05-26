# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PUT /peers/:id" do
  include_context "logged in"
  include_context "two people"

  let(:headers) { { "accept": "application/json" } }
  let(:params) { { peer: { relationship: :cancel_friendship } } }
  let(:url) { "/peers/#{other_peer.id}" }
  let(:current_peer) { Peer.first }
  let(:external_peer) { Peer.last }
  let(:setup_external_me) do
    expect_any_instance_of(Api::BaseController).to receive(:hook_into_current_peer).and_return ->(peer) do
      peer.update!(status: %i(friendship_requested_by_external))
    end
  end

  context "cancel_friendship" do
    before do
      other_peer.status = %i(friendship_requested_by_me)
      other_peer.save!
      setup_external_me
    end

    subject do
      put url, params: params, headers: headers
    end

    it "cancels the friendship" do
      subject
      expect(response).to have_http_status(:ok)

      expect(current_peer.status).to match_array(%i())
      expect(external_peer.status).to match_array(%i())
    end
  end
end
