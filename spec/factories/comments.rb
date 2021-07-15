# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id                 :bigint           not null, primary key
#  comment_type       :string           default("standard"), not null
#  content            :jsonb            not null
#  is_latest          :boolean          not null
#  signature          :binary           not null
#  sub_comments_count :bigint           default(0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  comment_counter_id :bigint           not null
#  parent_comment_id  :bigint
#  peer_id            :bigint           not null
#
# Indexes
#
#  index_comments_on_comment_counter_id  (comment_counter_id)
#  index_comments_on_parent_comment_id   (parent_comment_id)
#  index_comments_on_peer_id             (peer_id)
#
# Foreign Keys
#
#  fk_rails_...  (comment_counter_id => comment_counters.id)
#  fk_rails_...  (parent_comment_id => comments.id)
#  fk_rails_...  (peer_id => peers.id)
#
FactoryBot.define do
  factory :comment do
    comment_counter
    peer

    trait :standard do
      comment_type { :standard }
      content do
        {
          message: FFaker::Lorem.sentence
        }
      end
    end

    trait :with_reactions do
      after(:create) do |comment|
        create(:reaction_counter, subject: comment).tap do |reaction_counter|
          create_list(:reaction, 2, reaction_counter: reaction_counter)
        end
      end
    end

    before(:create) do |r|
      signing_key = r.peer.signing_key
      if r.peer == Current.peer
        signing_key = Current.profile.signing_key
      end

      r.signature ||= CommentsService::JsonSignature.new(r).call_test_raw_str(signing_key)
    end
  end
end
