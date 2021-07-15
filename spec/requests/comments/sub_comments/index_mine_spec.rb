# frozen_string_literal: true

require "rails_helper"
require_relative "../index_comments_context"

RSpec.describe "GET /posts/:post_id/comments" do
  include_context "logged in"
  include_context "comments index with all relationships"
  let(:comment_counter) { create(:comment_counter, subject: sample_post) }
  let(:parent_comment) { create(:comment, :standard, comment_counter: comment_counter) }
  let(:comments) { create_list(:comment, 2, :standard, comment_counter: comment_counter, parent_comment: parent_comment) }
  let(:my_comments) { create_list(:comment, 1, :standard, comment_counter: comment_counter, peer: context_my_peer, parent_comment_id: parent_comment.id) }
  let(:context_my_peer) { Current.peer }
  let(:context_other_peer) { Current.peer }

  let(:params) do
    {
      subject_type: "RemotePost",
      subject_id: remote_post.id,
    }
  end

  subject do
    get "/posts/#{remote_post.id}/comments?#{params.to_query}"
  end

  context "root comments" do
    it "lists comments" do
      subject

      expect(response).to have_http_status(:ok)
      expect(json[:comments]).to be_present
      expect(json[:comments].size).to eq(1)

      context_check_comment_have_reactions!
    end
  end

  context "with parent_comment_id" do
    let(:params) do
      super().merge(parent_comment_id: parent_comment.id)
    end

    it "lists the comments that belong to the parent comment" do
      subject

      expect(response).to have_http_status(:ok)
      expect(json[:comments]).to be_present
      expect(json[:comments].size).to eq(3)

      context_check_comment_have_reactions!
      context_check_comments_have_cache_comments!
    end
  end
end
