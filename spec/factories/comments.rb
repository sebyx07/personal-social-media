# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id                 :bigint           not null, primary key
#  comment_type       :string           default("standard"), not null
#  content            :jsonb            not null
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
    parent_comment { nil }
    comment_type { :standard }
    content do
      {
        message: "hello"
      }
    end
  end
end