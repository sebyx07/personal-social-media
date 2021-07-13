# frozen_string_literal: true

require "rails_helper"
require_relative "./index_comments_context"

RSpec.describe "GET /comments" do
  include_context "logged in"
  include_context "two people"
  include_context "comments index with all relationships"

  let(:cache_reactions) do
    reactions.map do |reaction|
      create(:cache_reaction,
             subject_type: reaction.subject_type,
             subject_id: reaction.subject_id,
             peer: other_peer, character: reaction.character,
             remote_reaction_id: reaction.id
      )
    end
  end

  let(:params) do
    {
      subject_type: "RemotePost",
      subject_id: remote_post.id
    }
  end

  before do
    setup_my_peer(statuses: :friend)
    setup_other_peer(statuses: :friend)
    remote_post.update(peer: other_peer)

    comments
  end

  subject do
    get "/posts/#{remote_post.id}/comments?#{params.to_query}"
  end

  it "lists the comments" do
    subject

    expect(response).to have_http_status(:ok)
    expect(json[:comments]).to be_present
    expect(json[:comments].size).to eq(3)

    context_check_comment_have_reactions!
  end
end
