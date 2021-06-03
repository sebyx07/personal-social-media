# frozen_string_literal: true

# == Schema Information
#
# Table name: cache_reactions
#
#  id                 :bigint           not null, primary key
#  character          :string           not null
#  subject_type       :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  peer_id            :bigint           not null
#  remote_reaction_id :bigint           not null
#  subject_id         :bigint           not null
#
# Indexes
#
#  idx_sub_type_sub_id_peer_id  (subject_type,subject_id,peer_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (peer_id => peers.id)
#
FactoryBot.define do
  factory :cache_reaction do
    character { "🤘" }
  end
end
