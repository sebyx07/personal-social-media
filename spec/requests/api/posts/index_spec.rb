# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /api/posts" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:posts) { create_list(:post, 2) }

  subject do
    stub_peer
    peer.update!(status: %i(friend))

    post "/api/posts", params: encrypt_params({}), headers: headers
  end

  it "lists posts" do
    posts
    subject

    expect(response).to have_http_status(:ok)
    expect(json[:posts]).to be_present
  end
end
