# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DELETE /posts/:id" do
  include_context "logged in"
  include_context "two people"
  let(:my_post) { create(:post, status: :ready) }

  before do
    expect(Post).to receive(:allow_propagate_to_remote?).at_least(:once).and_return(true)

    setup_my_peer(statuses: :friend)
    setup_other_peer(statuses: :friend)
  end

  subject do
    delete "/posts/#{my_post.id}"
  end

  it "destroys a post" do
    my_post

    expect do
      subject
    end.to change { Post.count }.by(-1)

    expect(response).to have_http_status(:redirect)
  end
end
