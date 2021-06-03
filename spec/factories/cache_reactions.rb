# == Schema Information
#
# Table name: cache_reactions
#
#  id           :bigint           not null, primary key
#  character    :string           not null
#  subject_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  subject_id   :bigint           not null
#
# Indexes
#
#  index_cache_reactions_on_subject  (subject_type,subject_id)
#
FactoryBot.define do
  factory :cache_reaction do
    character { "MyString" }
    subject { nil }
  end
end
