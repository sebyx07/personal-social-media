# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET /comments" do
  include_context "logged in"
  include_context "two people"
  let(:comments) { create_list(:comment, 3, :standard, comment_counter: comment_counter) }
  let(:comment_counter) { create(:comment_counter, subject: my_post) }
  let(:my_post) { create(:post) }
  let(:remote_post) { my_post.remote_post }

  let(:params) do
    {
      subject_type: "RemotePost",
      subject_id: remote_post.id
    }
  end

  before do
    setup_my_peer(statuses: :friend)
    setup_other_peer(statuses: :friend)
    remote_post.update(peer: other_peer)

    comments
  end

  subject do
    get "/comments?#{params.to_query}"
  end

  it "lists the comments" do
    subject

    expect(response).to have_http_status(:ok)
    expect(json[:comments]).to be_present
    expect(json[:comments].size).to eq(3)
  end
end
