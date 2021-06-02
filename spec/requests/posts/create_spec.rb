# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /posts" do
  include_context "logged in"
  include_context "two people"
  let(:example_post) { build(:post) }

  let(:params) { { post: { content: example_post.content, status: :ready } } }

  before do
    expect_any_instance_of(Post).to receive(:create_self_remote_post).and_return(true)
    expect(Post).to receive(:allow_propagate_to_remote?).and_return(true)

    setup_my_peer(statuses: :friend)
    setup_other_peer(statuses: :friend)
  end

  subject do
    post "/posts", params: params
  end

  it "creates a new post" do
    expect do
      subject
    end.to change { Post.count }.by(1)

    expect(response).to have_http_status(:redirect)
  end
end
