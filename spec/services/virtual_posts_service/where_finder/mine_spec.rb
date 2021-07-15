# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualPostsService::WhereFinder, type: :request do
  include_context "two people"
  let(:posts) { create_list(:post, 2, :with_reactions, :with_comments) }
  let(:pagination_params) { ActionController::Parameters.new({}) }
  let(:cache_comments) do
    posts.each do |post|
      post.comments.each do |comment|
        create(:cache_comment, :standard, peer_id: other_peer.id, remote_comment_id: comment.id,
               remote_parent_comment_id: comment.parent_comment_id, subject_type: "RemotePost",
               subject_id: post.remote_post.id,
        )
      end
    end
  end
  let(:cache_reactions) do
    posts.map do |post|
      reaction = post.reactions.first
      create(:cache_reaction,
        subject_type: reaction.subject_type,
        subject_id: reaction.subject_id,
        peer: my_peer, character: reaction.character,
        remote_reaction_id: reaction.id
      )
    end
  end

  let(:comment_reactions) do
    posts.each do |post|
      post.comments.each do |comment|
        reaction_counter = create(:reaction_counter, subject: comment)
        reaction = create(:reaction, peer: my_peer, reaction_counter: reaction_counter)
        create(:cache_reaction, character: reaction_counter.character,
                                subject_id: reaction_counter.subject_id, subject_type: reaction_counter.subject_type,
                                peer: my_peer, remote_reaction_id: reaction.id)
      end
    end
  end

  context "mine posts" do
    before do
      my_peer

      posts
      cache_comments
      cache_reactions
      comment_reactions

      Peer.where.not(id: Current.peer.id).find_each do |peer|
        peer.update!(status: %i(friend))
      end
    end

    subject do
      described_class.new(pagination_params, peer_id: my_peer.id).results
    end

    it "returns two posts" do
      expect(subject.size).to eq(2)

      subject.each do |v_post|
        expect(v_post).to be_a(VirtualPost)
        expect(v_post.post).to be_present

        VirtualPostPresenter.new(v_post).render.tap do |json|
          expect(json).to be_present
          expect(json[:reaction_counters]).to be_present
          expect(json[:latest_comments]).to be_present

          json[:reaction_counters].each do |reaction_counter|
            expect(reaction_counter[:has_reacted]).to be_truthy
          end

          json[:latest_comments].each do |comment|
            peer = comment[:peer]
            expect(peer[:status]).to match_array(:friend)

            expect(comment[:cache_comment_id]).to be_present

            expect(comment[:reaction_counters]).to be_present

            comment[:reaction_counters].each do |reaction_counter|
              expect(reaction_counter[:has_reacted]).to be_truthy
            end
          end
        end
      end
    end
  end
end
