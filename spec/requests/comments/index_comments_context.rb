# frozen_string_literal: true

RSpec.shared_examples "comments index with all relationships" do
  let(:comments) { create_list(:comment, 3, :standard, comment_counter: comment_counter) }
  let(:comment_counter) { create(:comment_counter, subject: sample_post) }
  let(:sample_post) { create(:post) }
  let(:remote_post) { sample_post.remote_post }
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
  end

  def context_check_comment_have_reactions!
    json[:comments].each do |comment|
      comment[:reaction_counters].each do |reaction_counters|
        expect(reaction_counters[:has_reacted]).to be_truthy
      end
    end
  end
end
