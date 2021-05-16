# frozen_string_literal: true

# == Schema Information
#
# Table name: peers
#
#  id          :bigint           not null, primary key
#  avatar_url  :string
#  domain_name :string           not null
#  name        :string
#  public_key  :binary           not null
#  status_mask :bigint           default(0), not null
#  verify_key  :binary
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Peer < ApplicationRecord
  include BitwiseAttribute

  attr_bitwise :status, values: %i[
    stranger friend full_block
    friendship_requested_by_me frienship_requested_by_external
    friendship_requested_by_me_blocked frienship_requested_by_external_blocked
    checked fake server_not_seen_recently
  ]

  def unfriendly?
    %i(full_block fake).include?(status)
  end

  def mark_as_fake!
    status << :fake
    save!
  end
end
