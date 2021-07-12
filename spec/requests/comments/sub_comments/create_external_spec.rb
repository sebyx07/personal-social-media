# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /posts/:post_id/comments" do
  include_context "logged in"
  include_context "two people"
  let(:sample_comment) { build(:comment, :standard) }
  let(:comment_counter) { create(:comment_counter, subject: sample_post) }
  let(:parent_comment) { create(:comment, :standard, comment_counter: comment_counter) }
  let(:sample_post) { create(:post) }
  let(:remote_post) { sample_post.remote_post }

  let(:params) do
    {
      comment: {
        content: sample_comment.content,
        subject_type: "RemotePost",
        subject_id: remote_post.id,
        comment_type: :standard,
        parent_comment_id: parent_comment.id
      }
    }
  end

  subject do
    remote_post.update!(peer: other_peer)

    post "/posts/#{remote_post.id}/comments", params: params
  end

  before do
    setup_my_peer(statuses: :friend)
    setup_other_peer(statuses: :friend)
    parent_comment
  end

  it "creates a new comment externally" do
    expect do
      subject
      expect(response).to have_http_status(:ok)
      parent_comment.reload
    end.to change { Comment.where.not(parent_comment_id: nil).count }.by(1)
      .and change { CommentCounter.count }.by(0)
      .and change { CacheComment.count }.by(1)
      .and change { parent_comment.sub_comments_count }.to(1)

    expect(json[:comment]).to be_present
    expect(json.dig(:comment, :content, :message)).to be_present
  end
end
