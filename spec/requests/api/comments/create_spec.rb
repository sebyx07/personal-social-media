# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /api/comments" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:sample_comment) { build(:comment, :standard) }
  let(:my_post) { create(:post) }
  let(:params) do
    {
      comment: {
        subject_type: "Post",
        subject_id: my_post.id,
        comment_type: :standard,
        content: sample_comment.content
      }
    }
  end

  before do
    stub_peer
    peer.update!(status: %i(friend))
  end

  it "creates two new comments" do
    expect do
      post "/api/comments", params: encrypt_params(params), headers: headers
      expect(response).to have_http_status(:ok)
    end.to change { Comment.count }.by(1)
       .and change { CommentCounter.count }.by(1)

    expect(json[:comment]).to be_present
    expect(json.dig(:comment, :content, :message)).to be_present
    created_comment_id = json.dig(:comment, :id)
    reset_response_json!

    sub_comment_params = params.dup.tap do |p|
      p[:comment][:parent_comment_id] = created_comment_id
    end

    parent_comment = Comment.find_by(id: created_comment_id)

    expect do
      post "/api/comments", params: encrypt_params(sub_comment_params), headers: headers
      expect(response).to have_http_status(:ok)
      parent_comment.reload
    end.to change { Comment.count }.by(1)
       .and change { CommentCounter.count }.by(0)
       .and change { parent_comment.sub_comments_count }.by(1)

    expect(json[:comment][:parent_comment_id]).to be_present
    expect(json.dig(:comment, :content, :message)).to be_present
  end
end
