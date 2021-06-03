# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DELETE /api/reactions/:id" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:reaction) { create(:reaction, peer: peer) }

  subject do
    stub_peer
    peer.update!(status: %i(friend))

    delete "/api/reactions/#{reaction.id}", params: encrypt_params({}), headers: headers
  end

  it "destroys the reaction" do
    reaction

    expect do
      subject
    end.to change { Reaction.count }.by(-1)

    expect(response).to have_http_status(:ok)
  end
end
