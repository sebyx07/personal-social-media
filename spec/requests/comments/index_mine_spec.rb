# frozen_string_literal: true

require "rails_helper"
require_relative "./index_comments_context"

RSpec.describe "GET /posts/:post_id/comments" do
  include_context "logged in"
  include_context "comments index with all relationships"
  let(:context_my_peer) { Current.peer }
  let(:context_other_peer) { Current.peer }

  let(:params) do
    {
      subject_type: "RemotePost",
      subject_id: remote_post.id
    }
  end

  subject do
    get "/posts/#{remote_post.id}/comments?#{params.to_query}"
  end

  it "lists the comments" do
    subject

    expect(response).to have_http_status(:ok)
    expect(json[:comments]).to be_present
    expect(json[:comments].size).to eq(3)

    context_check_comment_have_reactions!
  end
end
