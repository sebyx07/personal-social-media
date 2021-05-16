# frozen_string_literal: true

# == Schema Information
#
# Table name: peers
#
#  id          :bigint           not null, primary key
#  avatar_url  :string           default("stranger"), not null
#  domain_name :string           not null
#  name        :string           not null
#  public_key  :binary           not null
#  status      :string           not null
#  verify_key  :binary           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :peer do
    public_key do
      RbNaCl::PrivateKey.generate.public_key.to_s
    end
    verify_key do
      RbNaCl::SigningKey.generate.verify_key.to_s
    end
    domain_name { FFaker::Internet.domain_name }
    name { FFaker::Name.name }
  end
end
