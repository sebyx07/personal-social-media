# frozen_string_literal: true

# == Schema Information
#
# Table name: conversation_messages
#
#  id                             :bigint           not null, primary key
#  content                        :jsonb            not null
#  conversation_message_type      :string           not null
#  seen                           :boolean          not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  conversation_id                :bigint           not null
#  peer_id                        :bigint           not null
#  remote_conversation_message_id :bigint
#
# Indexes
#
#  index_conversation_messages_on_conversation_id  (conversation_id)
#  index_conversation_messages_on_peer_id          (peer_id)
#
# Foreign Keys
#
#  fk_rails_...  (conversation_id => conversations.id)
#  fk_rails_...  (peer_id => peers.id)
#
require "rails_helper"

RSpec.describe ConversationMessage, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
