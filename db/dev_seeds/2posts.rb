# frozen_string_literal: true

return if Post.count > 0
return if Current.profile.blank?

FactoryBot.create_list(:post, 4)
