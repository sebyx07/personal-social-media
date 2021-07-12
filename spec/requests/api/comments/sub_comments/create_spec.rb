# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /api/comments" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:sample_comment) { build(:comment, :standard) }
  let(:comment_counter) { create(:comment_counter, subject: my_post) }
  let(:parent_comment) { create(:comment, :standard, comment_counter: comment_counter) }
  let(:my_post) { create(:post) }
  let(:comment_attributes) do
    {
      subject_type: "Post",
      subject_id: my_post.id,
      comment_type: :standard,
      content: sample_comment.content,
      parent_comment_id: parent_comment.id
    }
  end

  let(:signature) do
    CommentsService::JsonSignature.new(prop_comment).call_test(peer.signing_key)
  end

  let(:prop_comment) do
    build(:comment, comment_attributes.slice(:comment_type, :content).merge(peer: peer)).tap do |comment|
      comment.comment_counter = build(:comment_counter, comment_attributes.slice(:subject_type, :subject_id))
    end
  end

  let(:params) do
    {
      comment: comment_attributes.merge(signature: signature)
    }
  end

  before do
    stub_peer
    peer.update!(status: %i(friend))
    parent_comment
  end

  it "creates two new comments" do
    expect do
      post "/api/comments", params: encrypt_params(params), headers: headers
      expect(response).to have_http_status(:ok)
    end.to change { Comment.where.not(parent_comment_id: nil).count }.by(1)
       .and change { CommentCounter.count }.by(0)

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
    end.to change { Comment.where.not(parent_comment_id: nil).count }.by(1)
       .and change { CommentCounter.count }.by(0)
       .and change { parent_comment.sub_comments_count }.by(1)

    expect(json[:comment][:parent_comment_id]).to be_present
    expect(json.dig(:comment, :content, :message)).to be_present
  end
end
