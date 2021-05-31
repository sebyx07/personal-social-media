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
    expect_any_instance_of(Post).to receive(:create_self_remote_post).and_return(true)

    other_peer.status = %i(friend)
    other_peer.save!
    setup_external_me
  end

  subject do
    expect(Post).to receive(:allow_propagate_to_remote?).and_return(true)
    delete "/posts/#{my_post.id}"
  end

  it "destroys a post" do
    remote_post

    expect do
      subject
    end.to change { Post.count }.to(0)
      .and change { RemotePost.count }.to(0)

    expect(response).to have_http_status(:redirect)
  end
end
