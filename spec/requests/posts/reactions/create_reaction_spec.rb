# frozen_string_literal: true

require "rails_helper"
require_relative "../../../shared_contexts/reactions_for_resource_context"

RSpec.describe "POST /posts/:post_id/reactions" do
  include_context "reactions for resource create"
  let(:sample_post) { create(:post) }
  let(:remote_post) { create(:remote_post, peer: other_peer, remote_post_id: sample_post.id) }
  let(:url) { "/posts/#{remote_post.id}/reactions" }

  it "works" do
    subject
    expect(response).to have_http_status(:ok)
  end
end
