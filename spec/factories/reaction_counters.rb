# frozen_string_literal: true

# == Schema Information
#
# Table name: reaction_counters
#
#  id              :bigint           not null, primary key
#  character       :string           not null
#  reactions_count :bigint           default(0), not null
#  subject_type    :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  subject_id      :bigint           not null
#
# Indexes
#
#  index_reaction_counters_on_character  (character)
#  index_reaction_counters_on_subject    (subject_type,subject_id)
emojis = %w(😀 😃 😄 😁 😆 😅 😂 🤣)
emojis_size = emojis.size
FactoryBot.define do
  factory :reaction_counter do
    sequence :character do |n|
      emojis[n % emojis_size]
    end
    before(:create) do |r|
      r.subject ||= create(:post)
    end
  end
end
