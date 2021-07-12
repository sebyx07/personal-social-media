# frozen_string_literal: true

require "rails_helper"

RSpec.describe "post /api/reactions" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:my_post) { create(:post) }
  let(:comment_counter) { create(:comment_counter, subject: my_post) }
  let(:parent_comment) { create(:comment, :standard, comment_counter: comment_counter) }
  let(:comment) { create(:comment, :standard, peer: peer, parent_comment_id: parent_comment.id, comment_counter: comment_counter) }

  let(:params) do
    {
      comments: {
        subject_id: comment.subject_id,
        subject_type: comment.subject_type,
        parent_comment_id: parent_comment.id
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
    expect(json[:comments].size).to equal(1)
  end
end
