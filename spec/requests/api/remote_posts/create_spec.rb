# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /api/remote_posts" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:params) do
    {
      post: { id: 4, post_type: :standard }
    }
  end

  subject do
    stub_peer
    peer.update!(status: %i(friend))

    post "/api/remote_posts", params: encrypt_params(params), headers: headers
  end

  it "creates a new remote post" do
    expect do
      subject
    end.to change { RemotePost.count }.by(1)

    expect(response).to have_http_status(:ok)
    expect(json[:ok]).to be_present
  end
end
