# frozen_string_literal: true

require "rails_helper"

RSpec.describe "post /api/reactions" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:reaction) { create(:reaction, peer: peer) }

  let(:params) do
    {
      reactions: {
        subject_id: reaction.subject_id,
        subject_type: reaction.subject_type,
      }
    }
  end

  subject do
    stub_peer
    peer.update!(status: %i(friend))
    reaction

    post "/api/reactions", params: encrypt_params(params), headers: headers
  end

  it "get reactions list" do
    subject
    expect(response).to have_http_status(:ok)
    expect(json[:reactions]).to be_present
  end
end
