# frozen_string_literal: true

return if Post.count > 0

FactoryBot.create_list(:post, 4)
