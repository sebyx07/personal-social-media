# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DELETE /peers/:id" do
  include_context "logged in"
  include_context "two people"

  let(:url) { "/peers/#{other_peer.id}" }
  let(:headers) { { "accept": "application/json" } }

  context "unfriend" do
    before do
      expect_any_instance_of(ApiService::Peers::UpdateRelationship).to receive(:destroy_peer).and_return true
      expect_any_instance_of(PeersService::Relationships::Unfriend).to receive(:update_peer!).and_return true
      setup_my_peer(statuses: :friend)
      setup_other_peer(statuses: :friend)
    end

    subject do
      delete url, headers: headers
    end

    it "destroys the friendship" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end
end
