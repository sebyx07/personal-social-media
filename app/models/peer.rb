# frozen_string_literal: true

# == Schema Information
#
# Table name: peers
#
#  id                  :bigint           not null, primary key
#  domain_name         :string           not null
#  email_hexdigest     :string
#  is_me               :boolean          default(FALSE), not null
#  last_seen_at        :datetime
#  name                :string
#  nickname            :string
#  public_key          :binary           not null
#  server_last_seen_at :datetime
#  status_mask         :bigint           default(0), not null
#  verify_key          :binary
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_peers_on_public_key   (public_key)
#  index_peers_on_status_mask  (status_mask)
#  index_peers_on_verify_key   (verify_key)
#
class Peer < ApplicationRecord
  include BitwiseAttribute

  attr_bitwise :status, values: %i[
    imported stranger friend
    full_block_by_me full_block_by_external
    friendship_requested_by_me friendship_requested_by_external
    friendship_requested_by_me_blocked friendship_requested_by_external_blocked
    fake
  ]

  has_many :remote_posts, dependent: :destroy

  validates :name, allow_blank: true, length: { maximum: 50, minimum: 4 }
  validates :nickname, allow_blank: true, length: { maximum: 18, minimum: 4 }
  validates :email_hexdigest, allow_blank: true, length: { is: 32 }
  validates :public_key, presence: true, length: { is: 32 }
  validates :verify_key, allow_blank: true, length: { is: 32 }
  validates :is_me, uniqueness: true, if: -> { is_me? } unless Rails.env.test?
  validates :public_key, uniqueness: true, if: -> { !fake? } unless Rails.env.test?
  has_many :remote_posts, dependent: :delete_all

  if Rails.env.production? && !DeveloperService::IsEnabled.is_enabled?
    validates :domain_name, domain_name: true, presence: true
  else
    validates :domain_name, presence: true
  end

  def unfriendly?
    (PeersService::RelationshipStatus::UNFRIENDLY & status).present?
  end

  def neutral?
    !unfriendly?
  end

  def friendly?
    return false if unfriendly?
    (PeersService::RelationshipStatus::FRIENDLY & status).present?
  end

  def sync_from_whoami_remote!
    will_retry = false
    PeersService::SyncFromWhoAmIRemote.new(self, will_retry: will_retry).call!
  end

  def api_url(url)
    PeersService::BuildApiUrl.new(self).call(url)
  end

  def server_not_seen_recently?
    server_last_seen_at.blank? || server_last_seen_at < 3.days.ago
  end

  def mark_as_fake!
    status << :fake
    save! if persisted?
  end
end
