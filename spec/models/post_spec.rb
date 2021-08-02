# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :jsonb            not null
#  name       :string           not null
#  post_type  :string           default("standard"), not null
#  status     :string           default("pending"), not null
#  views      :bigint           default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_posts_on_name  (name) USING gin
#
require "rails_helper"

RSpec.describe Post, type: :model do
end
