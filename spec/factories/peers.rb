# frozen_string_literal: true

# == Schema Information
#
# Table name: peers
#
#  id                  :bigint           not null, primary key
#  domain_name         :string           not null
#  email_hexdigest     :string
#  is_me               :boolean          default(FALSE), not null
#  last_seen_at        :datetime
#  name                :string
#  nickname            :string
#  public_key          :binary           not null
#  server_last_seen_at :datetime
#  status_mask         :bigint           default(0), not null
#  verify_key          :binary
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_peers_on_public_key   (public_key)
#  index_peers_on_status_mask  (status_mask)
#  index_peers_on_verify_key   (verify_key)
#
FactoryBot.define do
  factory :peer do
    signing_key do
      RbNaCl::SigningKey.generate
    end
    verify_key do
      signing_key.verify_key.to_s
    end

    private_key do
      RbNaCl::PrivateKey.generate
    end

    public_key do
      private_key.public_key.to_s
    end

    domain_name { FFaker::Internet.domain_name }
    name { FFaker::Name.name }
    nickname { (FFaker::Internet.user_name + "000").first(18) }
    email_hexdigest do
      Digest::MD5.hexdigest(FFaker::Internet.email)
    end
  end
end
