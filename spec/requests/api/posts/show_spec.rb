# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /api/posts/:id" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:post_record) { create(:post) }

  subject do
    stub_peer
    peer.update!(status: %i(friend))

    post "/api/posts/#{post_record.id}", params: encrypt_params({}), headers: headers
  end

  it "shows the post" do
    subject

    expect(response).to have_http_status(:ok)
    expect(json[:post]).to be_present
  end
end
