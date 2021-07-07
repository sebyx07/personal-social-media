# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PATCH /api/comments/:id" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:comment) { create(:comment, :standard, peer: peer) }
  let(:sample_comment) { build(:comment, :standard) }
  let(:comment_attributes) do
    {
      content: sample_comment.content
    }
  end

  let(:params) do
    {
      comment: comment_attributes.merge(signature: signature)
    }
  end

  let(:prop_comment) do
    comment.dup.tap do |c|
      c.assign_attributes(comment_attributes)
    end
  end

  let(:signature) do
    CommentsService::JsonSignature.new(prop_comment).call_test(peer.signing_key)
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
    expect(json.dig(:comment, :content, :message)).to be_present
  end
end
