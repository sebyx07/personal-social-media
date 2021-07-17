# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :jsonb            not null
#  post_type  :string           default("standard"), not null
#  signature  :binary           not null
#  status     :string           default("pending"), not null
#  views      :bigint           default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require "rails_helper"

RSpec.describe Post, type: :model do
end
