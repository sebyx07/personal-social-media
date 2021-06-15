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
#
class ReactionCounter < ApplicationRecord
  belongs_to :subject, polymorphic: true

  validates :character, presence: true, uniqueness: { scope: [:subject_type, :subject_id] }, format: {
    with: Unicode::Emoji::REGEX_WELL_FORMED
  }, on: :create
  validates :subject_type, presence: true, inclusion: { in: %w(Post Comment) }

  has_many :reactions, dependent: :delete_all
end
