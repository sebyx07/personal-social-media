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
require "rails_helper"

RSpec.describe Peer, type: :model do
end
