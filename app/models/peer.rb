# frozen_string_literal: true

# == Schema Information
#
# Table name: peers
#
#  id          :bigint           not null, primary key
#  avatar_url  :string           default("stranger"), not null
#  domain_name :string           not null
#  name        :string           not null
#  public_key  :binary           not null
#  status      :string           not null
#  verify_key  :binary           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Peer < ApplicationRecord
end
