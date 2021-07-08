# frozen_string_literal: true

# == Schema Information
#
# Table name: remote_posts
#
#  id             :bigint           not null, primary key
#  post_type      :string           default("standard"), not null
#  show_in_feed   :boolean          default(FALSE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  peer_id        :bigint           not null
#  remote_post_id :bigint           not null
#
# Indexes
#
#  index_remote_posts_on_peer_id                     (peer_id)
#  index_remote_posts_on_remote_post_id_and_peer_id  (remote_post_id,peer_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (peer_id => peers.id)
#
class RemotePost < ApplicationRecord
  belongs_to :peer

  validates :remote_post_id, presence: true, uniqueness: { scope: :peer_id }
  validates :post_type, presence: true
  str_enum :post_type, %i(standard)
  has_many :cache_reactions, -> do
    joins(<<-SQL
LEFT JOIN remote_posts
ON cache_reactions.peer_id = remote_posts.peer_id AND cache_reactions.subject_type = 'RemotePost' AND cache_reactions.subject_id = remote_posts.remote_post_id
    SQL
         )
  end, dependent: :delete_all, as: :subject

  has_many :cache_comments, -> do
    joins(<<-SQL
LEFT JOIN remote_posts
ON cache_comments.peer_id = remote_posts.peer_id AND cache_comments.subject_type = 'RemotePost' AND cache_comments.subject_id = remote_posts.remote_post_id
    SQL
         )
  end, dependent: :delete_all, as: :subject

  def local_post
    return nil if peer_id != Current.peer.id
    Post.find_by!(id: remote_post_id)
  end
end
