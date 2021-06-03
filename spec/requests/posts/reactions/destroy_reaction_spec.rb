# frozen_string_literal: true

require "rails_helper"
require_relative "../../../shared_contexts/reactions_for_resource_context"

RSpec.describe "POST /posts/:post_id/reactions" do
  include_context "reactions for resource destroy"
  let(:sample_post) { create(:post) }
  let(:remote_post) { create(:remote_post, peer: other_peer, remote_post_id: sample_post.id) }

  let(:cache_reaction) { create(:cache_reaction, subject: remote_post, peer: other_peer, remote_reaction_id: reaction.id) }
  let(:reaction_counter) { create(:reaction_counter, subject: sample_post) }
  let(:reaction) { create(:reaction, reaction_counter: reaction_counter, peer: my_peer) }

  let(:url) { "/posts/#{remote_post.id}/reactions" }

  it "works" do
    subject
    expect(response).to have_http_status(:ok)
  end
end
