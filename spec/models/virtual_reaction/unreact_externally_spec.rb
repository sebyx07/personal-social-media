# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualReaction, type: :request do
  include_context "two people"

  describe ".react_for_remote_post" do
    let(:sample_post) { create(:post) }
    let(:remote_post) { create(:remote_post, peer: other_peer, remote_post_id: sample_post.id) }
    let(:cache_reaction) { create(:cache_reaction, subject: remote_post, peer: other_peer, remote_reaction_id: reaction.id) }
    let(:reaction_counter) { create(:reaction_counter, subject: sample_post) }
    let(:reaction) { create(:reaction, reaction_counter: reaction_counter, peer: my_peer) }

    context "locally" do
      before do
        cache_reaction
        reaction

        setup_my_peer(statuses: :friend)
        setup_other_peer(statuses: :friend)
      end

      subject do
        described_class.react_for_remote_post(remote_post.id, cache_reaction.character, remove_reaction: true)
      end

      it "destroys a CacheReaction and a Reaction" do
        expect do
          subject
        end.to change { Reaction.count }.by(-1)
          .and change { CacheReaction.count }.by(-1)
      end
    end
  end
end
