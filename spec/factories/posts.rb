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
FactoryBot.define do
  factory :post do
    content do
      {
        message: FFaker::Lorem.phrase
      }
    end
    status { :ready }

    trait :with_reactions do
      after(:create) do |post|
        create(:reaction_counter, subject: post).tap do |reaction_counter|
          create_list(:reaction, 2, reaction_counter: reaction_counter)
        end
      end
    end

    trait :with_comments do
      after(:create) do |post|
        create(:comment_counter, subject: post).tap do |comment_counter|
          create_list(:comment, 2, :standard, comment_counter: comment_counter)
        end
      end
    end
  end
end
