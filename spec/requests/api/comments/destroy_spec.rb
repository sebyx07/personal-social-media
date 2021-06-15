# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DELETE /api/comments/:id" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:comment) { create(:comment, :standard, peer: peer) }

  subject do
    stub_peer
    peer.update!(status: %i(friend))

    delete "/api/comments/#{comment.id}", params: encrypt_params({}), headers: headers
  end

  it "destroys the comment" do
    comment

    expect do
      subject
    end.to change { Comment.count }.by(-1)

    expect(response).to have_http_status(:ok)
  end
end
