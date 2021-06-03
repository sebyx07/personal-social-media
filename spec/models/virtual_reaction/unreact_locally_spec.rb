# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualReaction do
  describe ".react_for_remote_post" do
    let(:post) { create(:post) }
    let(:remote_post) { post.remote_post }
    let(:cache_reaction) { create(:cache_reaction, subject: post, peer: Current.peer, remote_reaction_id: reaction.id) }
    let(:reaction_counter) { create(:reaction_counter, subject: post) }
    let(:reaction) { create(:reaction, reaction_counter: reaction_counter, peer: Current.peer) }

    context "locally" do
      before do
        cache_reaction
        reaction
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
