# frozen_string_literal: true

RSpec.shared_examples "comments index with all relationships" do
  let(:sample_post) { create(:post) }
  let(:remote_post) { sample_post.remote_post }

  let(:comments) { create_list(:comment, 2, :standard, comment_counter: comment_counter) }
  let(:comment_counter) { create(:comment_counter, subject: sample_post) }
  let(:my_comments) { create_list(:comment, 1, :standard, comment_counter: comment_counter, peer: context_my_peer) }
  let(:cache_comments) do
    my_comments.map do |comment|
      create(:cache_comment, :standard, subject_type: "RemotePost", subject_id: remote_post.id, peer: context_other_peer, remote_comment_id: comment.id)
    end
  end

  let(:reaction_counters) do
    comments.map do |comment|
      create(:reaction_counter, subject: comment)
    end
  end
  let(:reactions) do
    reaction_counters.map do |reaction_counter|
      create(:reaction, reaction_counter: reaction_counter, peer: Current.peer)
    end.flatten
  end
  let(:cache_reactions) do
    reactions.map do |reaction|
      create(:cache_reaction,
             subject_type: reaction.subject_type,
             subject_id: reaction.subject_id,
             peer: reaction.peer, character: reaction.character,
             remote_reaction_id: reaction.id
      )
    end
  end

  before do
    comments
    cache_reactions
    cache_comments
  end

  def context_check_comment_have_reactions!
    json[:comments].each do |comment|
      comment[:reaction_counters].each do |reaction_counters|
        expect(reaction_counters[:has_reacted]).to be_truthy
      end
    end
  end

  def context_check_comments_have_cache_comments!
    json[:comments].each_with_index do |j_comment, idx|
      if idx == 0
        expect(j_comment[:cache_comment_id]).to be_present
      else
        expect(j_comment[:cache_comment_id]).to be_blank
      end
    end
  end
end
