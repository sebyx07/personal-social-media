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
class Profile < ApplicationRecord
  attribute :installation_password, :string

  has_secure_password validations: false
  validates :password, presence: true, length: { is: 32 }, on: :create
  validates :password, allow_blank: true, length: { is: 32 }

  encrypts :pk, type: :binary
  validates :pk_ciphertext, presence: true
  before_validation :generate_private_key, on: :create

  encrypts :sk, type: :binary
  validates :pk_ciphertext, presence: true
  before_validation :generate_signing_key, on: :create

  validates :name, presence: true, length: { maximum: 64 }
  sanitize_attributes :email, with: :squish

  validates :nickname, presence: true, length: { maximum: 128 }
  sanitize_attributes :email, with: %i(downcase no_spaces)

  validates :email, presence: true, length: { maximum: 64 }, email: true
  sanitize_attributes :email, with: %i(downcase no_spaces)

  validates :installation_password, inclusion: { in: [ Rails.application.secrets.installation_password ] }, on: :create
  before_validation :generate_password, on: :create

  def private_key
    @private_key ||= RbNaCl::PrivateKey.new(pk)
  end

  private
    def generate_private_key
      self.pk ||= ProfilesService::CreateNewPrivateKey.new.call
    end

    def generate_signing_key
      self.sk ||= ProfilesService::CreateNewSigningKey.new.call
    end

    def generate_password
      self.password_plain = SecureRandom.urlsafe_base64(24)
      self.password = password_plain
    end
end
