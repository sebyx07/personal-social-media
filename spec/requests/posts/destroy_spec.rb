# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DELETE /posts/:id" do
  include_context "logged in"
  include_context "two people"
  let(:my_post) { create(:post, status: :ready) }
  let(:remote_post) { create(:remote_post, peer: current_peer, remote_post_id: my_post.id) }

  let(:setup_external_me) do
    expect_any_instance_of(Api::BaseController).to receive(:hook_into_current_peer).and_return ->(peer) do
      peer.update!(status: %i(friend))
    end
  end

  before do
    other_peer.status = %i(friend)
    other_peer.save!
    setup_external_me
  end

  subject do
    delete "/posts/#{my_post.id}"
  end

  it "creates a new post" do
    expect_any_instance_of(Post).to receive(:propagate_to_peers).and_return(true)
    remote_post

    expect do
      subject
    end.to change { Post.count }.to(0)
      .and change { RemotePost.count }.to(0)

    expect(response).to have_http_status(:redirect)
  end
end
