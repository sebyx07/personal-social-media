# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /posts" do
  include_context "logged in"
  include_context "two people"
  let(:example_post) { build(:post) }

  let(:params) { { post: { content: example_post.content, status: :ready } } }

  let(:current_peer) { Peer.first }
  let(:external_peer) { Peer.last }

  let(:setup_external_me) do
    expect_any_instance_of(Api::BaseController).to receive(:hook_into_current_peer).and_return ->(peer) do
      peer.update!(status: %i(friend))
    end
  end

  before do
    expect(::Post).to receive(:allow_propagate_to_remote?).and_return(true)
    other_peer.status = %i(friend)
    other_peer.save!
    setup_external_me
  end

  subject do
    post "/posts", params: params
  end

  it "creates a new post" do
    expect do
      subject
    end.to change { Post.count }.to(1)
      .and change { RemotePost.count }.to(1)

    expect(response).to have_http_status(:redirect)
  end
end
