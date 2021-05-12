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
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :profile do
    email { "me@example.com" }
    name { "MyName" }
    nickname { "me" }
    installation_password { Rails.application.secrets.installation_password }
  end
end
