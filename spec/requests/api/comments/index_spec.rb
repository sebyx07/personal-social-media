# frozen_string_literal: true

require "rails_helper"

RSpec.describe "post /api/reactions" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:comment) { create(:comment, :standard, peer: peer) }

  let(:params) do
    {
      comments: {
        subject_id: comment.subject_id,
        subject_type: comment.subject_type,
      }
    }
  end

  subject do
    stub_peer
    peer.update!(status: %i(friend))
    comment

    post "/api/comments", params: encrypt_params(params), headers: headers
  end

  it "get comments list" do
    subject
    expect(response).to have_http_status(:ok)
    expect(json[:comments]).to be_present
  end
end
