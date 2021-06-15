# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /comments" do
  include_context "logged in"
  include_context "two people"
  let(:sample_comment) { build(:comment, :standard) }
  let(:sample_post) { create(:post) }
  let(:remote_post) { sample_post.remote_post }

  let(:params) { { comment: { content: sample_comment.content, subject_type: "RemotePost", subject_id: remote_post.id } } }

  subject do
    remote_post.update!(peer: other_peer)

    post "/comments", params: params
  end

  before do
    setup_my_peer(statuses: :friend)
    setup_other_peer(statuses: :friend)
  end

  it "creates a new comment externally" do
    expect do
      subject
      expect(response).to have_http_status(:ok)
    end.to change { Comment.count }.by(1)
      .and change { CommentCounter.count }.by(1)

    expect(json[:comment]).to be_present
  end
end
