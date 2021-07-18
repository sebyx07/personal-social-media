# frozen_string_literal: true

# == Schema Information
#
# Table name: cache_comments
#
#  id                       :bigint           not null, primary key
#  comment_type             :string           not null
#  content                  :jsonb            not null
#  subject_type             :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  peer_id                  :bigint           not null
#  remote_comment_id        :bigint           not null
#  remote_parent_comment_id :bigint
#  subject_id               :bigint           not null
#
# Indexes
#
#  index_cache_comments_on_peer_id  (peer_id)
#  index_cache_comments_on_subject  (subject_type,subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (peer_id => peers.id)
#
class CacheComment < ApplicationRecord
  belongs_to :peer

  str_enum :comment_type, Comment.comment_types
  validates :comment_type, presence: true

  store :content, accessors: %i(message)
  validates :message, presence: true, length: { maximum: 1000 }, if: -> { standard? }

  def local_comment
    @local_comment ||= Comment.find_by(id: remote_comment_id, peer: Current.peer)
  end

  def raw_signature
    CommentsService::RawSignature.new(self, Current.peer)
  end
end
