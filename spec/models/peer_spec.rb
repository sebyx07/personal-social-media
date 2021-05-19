# frozen_string_literal: true

# == Schema Information
#
# Table name: peers
#
#  id              :bigint           not null, primary key
#  domain_name     :string           not null
#  email_hexdigest :string
#  is_me           :boolean
#  name            :string
#  nickname        :string
#  public_key      :binary           not null
#  status_mask     :bigint           default(0), not null
#  verify_key      :binary
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require "rails_helper"

RSpec.describe Peer, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
