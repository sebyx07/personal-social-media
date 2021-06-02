# frozen_string_literal: true

# == Schema Information
#
# Table name: remote_posts
#
#  id             :bigint           not null, primary key
#  post_type      :string           default("standard"), not null
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
end