# frozen_string_literal: true

# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text
#  post_type  :string           default("standard"), not null
#  status     :string           default("pending"), not null
#  views      :bigint           default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :post do
    content { FFaker::Lorem.phrase }
    status { :ready }
  end
end
