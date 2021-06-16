# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PATCH /api/comments/:id" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:comment) { create(:comment, :standard, peer: peer) }
  let(:sample_comment) { build(:comment, :standard) }

  let(:params) do
    {
      comment: {
        content: sample_comment.content
      }
    }
  end

  subject do
    stub_peer
    peer.update!(status: %i(friend))

    patch "/api/comments/#{comment.id}", params: encrypt_params(params), headers: headers
  end

  it "updates the comment" do
    comment

    expect do
      subject
      expect(response).to have_http_status(:ok)
      comment.reload
    end.to change { comment.content }.to(sample_comment.content)

    expect(json[:comment]).to be_present
  end
end
