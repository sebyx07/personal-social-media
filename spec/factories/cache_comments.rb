# frozen_string_literal: true

# == Schema Information
#
# Table name: cache_comments
#
#  id                       :bigint           not null, primary key
#  comment_type             :string           not null
#  content                  :jsonb            not null
#  subject_type             :string           not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  peer_id                  :bigint           not null
#  remote_comment_id        :bigint           not null
#  remote_parent_comment_id :bigint
#  subject_id               :bigint           not null
#
# Indexes
#
#  index_cache_comments_on_peer_id  (peer_id)
#  index_cache_comments_on_subject  (subject_type,subject_id)
#
# Foreign Keys
#
#  fk_rails_...  (peer_id => peers.id)
#
FactoryBot.define do
  factory :cache_comment do
    remote_id { "" }
    comment_type { "MyString" }
    content { "" }
  end
end
