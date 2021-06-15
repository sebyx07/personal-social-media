# frozen_string_literal: true

# == Schema Information
#
# Table name: comment_counters
#
#  id             :bigint           not null, primary key
#  comments_count :bigint           default(0), not null
#  subject_type   :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  subject_id     :bigint           not null
#
# Indexes
#
#  index_comment_counters_on_subject  (subject_type,subject_id)
#
class CommentCounter < ApplicationRecord
  belongs_to :subject, polymorphic: true
  validates :subject_type, presence: true, uniqueness: { scope: :subject_id }
  validates :subject_id, presence: true

  validates :subject_type, inclusion: { in: %w(Post Comment) }
end
