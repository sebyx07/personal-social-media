# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  name            :string           not null
#  nickname        :string           not null
#  password_digest :string           not null
#  password_plain  :string
#  pk_ciphertext   :text             not null
#  sk_ciphertext   :text             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :profile do
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    nickname {  (FFaker::Internet.user_name + "000").first(18) }
    installation_password { Rails.application.secrets.installation_password }
  end
end
