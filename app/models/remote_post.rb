# frozen_string_literal: true

# == Schema Information
#
# Table name: remote_posts
#
#  id             :bigint           not null, primary key
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

  class << self
    def safe_create!(*options)
      return create!(options) unless Rails.env.test?

      record = new(*options)
      record.save if record.valid?
    end
  end
end
