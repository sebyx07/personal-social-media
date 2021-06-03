# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualReaction do
  describe ".react_for_remote_post" do
    let(:post) { create(:post) }
    let(:remote_post) { post.remote_post }
    let(:sample_react) { build(:cache_reaction) }

    context "locally" do
      subject do
        described_class.react_for_remote_post(remote_post.id, sample_react.character)
      end

      it "creates a CacheReaction, a Reaction and ReactionCounter" do
        expect do
          subject
        end.to change { CacheReaction.count }.by(1)
          .and change { Reaction.count }.by(1)
          .and change { ReactionCounter.count }.by(1)
      end
    end
  end
end
