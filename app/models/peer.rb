# frozen_string_literal: true

# == Schema Information
#
# Table name: peers
#
#  id              :bigint           not null, primary key
#  domain_name     :string           not null
#  email_hexdigest :string
#  name            :string
#  nickname        :string
#  public_key      :binary           not null
#  status_mask     :bigint           default(0), not null
#  verify_key      :binary
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class Peer < ApplicationRecord
  include BitwiseAttribute

  attr_bitwise :status, values: %i[
    stranger friend
    full_block_by_me full_block_by_external
    friendship_requested_by_me frienship_requested_by_external
    friendship_requested_by_me_blocked frienship_requested_by_external_blocked
    checked fake server_not_seen_recently
  ]

  validates :name, allow_blank: true, length: { maximum: 50, minimum: 4 }
  validates :nickname, allow_blank: true, length: { maximum: 18, minimum: 4 }
  validates :domain_name, domain_name: true, presence: true
  validates :email_hexdigest, allow_blank: true, length: { is: 32 }
  validates :public_key, presence: true, length: { is: 32 }
  validates :verify_key, allow_blank: true, length: { is: 32 }

  def unfriendly?
    PeersService::RelationshipStatus::UNFRIENDLY.include?(status)
  end

  def mark_as_fake!
    status << :fake
    save!
  end
end
