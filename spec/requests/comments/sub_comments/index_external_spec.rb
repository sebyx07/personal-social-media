# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET /comments" do
  include_context "logged in"
  include_context "two people"
  let(:comment_counter) { create(:comment_counter, subject: my_post) }
  let(:parent_comment) { create(:comment, :standard, comment_counter: comment_counter) }
  let(:comments) { create_list(:comment, 3, :standard, comment_counter: comment_counter, parent_comment: parent_comment) }
  let(:comment_counter) { create(:comment_counter, subject: my_post) }
  let(:my_post) { create(:post) }
  let(:remote_post) { my_post.remote_post }

  let(:params) do
    {
      subject_type: "RemotePost",
      subject_id: remote_post.id,
    }
  end

  before do
    setup_my_peer(statuses: :friend)
    setup_other_peer(statuses: :friend)
    remote_post.update(peer: other_peer)

    comments
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
    end
  end
end
