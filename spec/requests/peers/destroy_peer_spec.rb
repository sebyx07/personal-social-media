# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DELETE /peers/:id" do
  include_context "logged in"
  include_context "two people"

  let(:url) { "/peers/#{other_peer.id}" }
  let(:headers) { { "accept": "application/json" } }
  let(:current_peer) { Peer.first }
  let(:external_peer) { Peer.last }
  let(:setup_external_me) do
    expect_any_instance_of(Api::BaseController).to receive(:hook_into_current_peer).and_return ->(peer) do
      peer.update!(status: %i(friend))
    end
  end

  context "unfriend" do
    before do
      other_peer.status = %i(friend)
      other_peer.save!
      setup_external_me
    end

    subject do
      delete url, headers: headers
    end

    it "destroys the friendship" do
      subject
      expect(response).to have_http_status(:ok)

      expect(current_peer).to be_blank
      expect(external_peer).to be_blank
    end
  end
end
