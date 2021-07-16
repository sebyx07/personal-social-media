# frozen_string_literal: true

# == Schema Information
#
# Table name: conversations
#
#  id                    :bigint           not null, primary key
#  is_focused            :boolean          default(FALSE), not null
#  unread_messages_count :bigint           default(0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  peer_id               :bigint           not null
#
# Indexes
#
#  index_conversations_on_peer_id  (peer_id)
#
# Foreign Keys
#
#  fk_rails_...  (peer_id => peers.id)
#
require "rails_helper"

RSpec.describe Conversation, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
