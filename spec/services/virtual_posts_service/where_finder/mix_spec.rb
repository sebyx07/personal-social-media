# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualPostsService::WhereFinder, type: :request do
  include_context "two people"
  let(:posts) { create_list(:post, 2, :with_reactions, :with_comments) }
  let(:other_posts) do
    output = []
    take_over_wrap! do
      output += create_list(:post, 2, :with_reactions, :with_comments)
    end
    output
  end
  let(:other_remote_posts) do
    RemotePost.where(remote_post_id: other_posts.map(&:id)).tap do |remote_posts|
      remote_posts.update_all(peer_id: other_peer.id, show_in_feed: true)
    end
  end

  let(:pagination_params) { ActionController::Parameters.new({}) }
  let(:other_posts_remote_posts) do
    other_posts.map do |post|
      {
        post: post,
        remote_post: RemotePost.find_by(remote_post_id: post.id)
      }
    end
  end

  # Cache Comments

  let(:my_cache_comments) do
    posts.each do |post|
      post.comments.each do |comment|
        create(:cache_comment, :standard, peer_id: my_peer.id, remote_comment_id: comment.id,
               remote_parent_comment_id: comment.parent_comment_id, subject_type: "Post",
               subject_id: post.id,
        )
      end
    end
  end

  let(:other_cache_comments) do
    other_posts.each do |post|
      post.comments.each do |comment|
        create(:cache_comment, :standard, peer_id: other_peer.id, remote_comment_id: comment.id,
               remote_parent_comment_id: comment.parent_comment_id, subject_type: "RemotePost",
               subject_id: get_other_remote_post(post).id,
        )
      end
    end
  end

  # Cache Reactions

  let(:other_cache_reactions) do
    other_posts.map do |post|
      reaction = post.reactions.first
      create(:cache_reaction,
             subject_type: "RemotePost",
             subject_id: get_other_remote_post(post).id,
             peer: other_peer, character: reaction.character,
             remote_reaction_id: reaction.id
      )
    end
  end

  let(:my_cache_reactions) do
    posts.map do |post|
      reaction = post.reactions.first
      create(:cache_reaction,
             subject_type: "Post",
             subject_id: post.id,
             peer: my_peer, character: reaction.character,
             remote_reaction_id: reaction.id
      )
    end
  end

  # Comments reactions

  let(:other_comment_reactions) do
    other_posts.each do |post|
      post.comments.each do |comment|
        reaction_counter = create(:reaction_counter, subject: comment)
        reaction = create(:reaction, peer: my_peer, reaction_counter: reaction_counter)
        create(:cache_reaction, character: reaction_counter.character,
               subject_id: reaction_counter.subject_id, subject_type: reaction_counter.subject_type,
               peer: other_peer, remote_reaction_id: reaction.id)
      end
    end
  end

  let(:my_comment_reactions) do
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

  # Comments reactions end

  context "mixed posts" do
    before do
      posts
      other_cache_comments
      other_cache_reactions
      other_comment_reactions

      my_cache_comments
      my_cache_reactions
      my_comment_reactions

      setup_my_peer(statuses: :friend)
      setup_other_peer(statuses: :friend)

      Peer.where.not(id: Current.peer.id).find_each do |peer|
        peer.update!(status: %i(friend))
      end
    end

    subject do
      described_class.new(pagination_params, post_type: :standard, show_from_feed_only: true).results
    end

    it "returns 4 post" do
      expect(subject.size).to eq(4)
      subject.each_with_index do |v_post, index|
        expect(v_post).to be_a(VirtualPost)
        VirtualPostPresenter.new(v_post).render.tap do |json|
          expect(json).to be_present
          expect(json[:is_valid]).to be_truthy

          expect(json[:latest_comments]).to be_present
          json[:latest_comments].each do |comment|
            peer = comment[:peer]
            expect(peer[:status]).to match_array(:friend)
            expect(comment[:cache_comment_id]).to be_truthy
          end

          expect(json[:reaction_counters]).to be_present
          json[:reaction_counters].each do |reaction_counter|
            expect(reaction_counter[:has_reacted]).to be_truthy
          end

          json[:latest_comments].each do |comment|
            expect(comment[:reaction_counters]).to be_present
          end
        end
      end
    end
  end

  def get_other_remote_post(post)
    other_posts_remote_posts.detect do |h|
      h[:post] == post
    end[:remote_post]
  end
end
