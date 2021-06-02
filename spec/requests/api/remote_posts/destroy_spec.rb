# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DELETE /api/remote_posts/:id" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:remote_post) { create(:remote_post, peer: peer) }

  subject do
    stub_peer
    peer.update!(status: %i(friend))

    delete "/api/remote_posts/#{remote_post.remote_post_id}", params: encrypt_params({}), headers: headers
  end

  it "delete a remote post" do
    remote_post

    expect do
      subject
    end.to change { RemotePost.count }.by(-1)

    expect(response).to have_http_status(:ok)
    expect(json[:ok]).to be_present
  end
end
