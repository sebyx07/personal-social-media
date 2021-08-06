# frozen_string_literal: true

# == Schema Information
#
# Table name: profiles
#
#  id                         :bigint           not null, primary key
#  backup_password_ciphertext :string           not null
#  email                      :string           not null
#  name                       :string           not null
#  nickname                   :string           not null
#  password_digest            :string           not null
#  password_plain             :string
#  pk_ciphertext              :text             not null
#  sk_ciphertext              :text             not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
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

  encrypts :backup_password
  validates :backup_password, presence: true
  before_validation :generate_backup_password, on: :create

  after_create :generate_self_peer!
  after_commit :generate_settings, on: :create
  after_commit :run_dev_seeds_again, on: :create if Rails.env.development?

  validates :name, presence: true, length: { maximum: 50, minimum: 4 }
  sanitize_attributes :email, with: :squish

  validates :nickname, presence: true, length: { maximum: 18, minimum: 4 }
  sanitize_attributes :email, with: %i(downcase no_spaces)

  validates :email, presence: true, length: { maximum: 128 }, email: true
  sanitize_attributes :email, with: %i(downcase no_spaces)

  validates :installation_password,
            inclusion: { in: [ Rails.application.secrets.installation_password ] },
            length: { is: 128 },
            on: :create
  before_validation :generate_password, on: :create

  delegate :public_key, to: :private_key
  def private_key
    @private_key ||= RbNaCl::PrivateKey.new(pk)
  end

  delegate :verify_key, to: :signing_key
  def signing_key
    @signing_key ||= RbNaCl::SigningKey.new(sk)
  end

  def email_hexdigest
    Digest::MD5.hexdigest(email)
  end

  def domain_name
    SettingsService::WebUrl.new.host
  end

  def peer
    @peer ||= Peer.find_by(is_me: true)
  end

  def generate_settings
    return if Current.settings.present?
    Setting.create!
  end

  def generate_password!
    generate_password
    save!
    self.reload
  end

  private
    def generate_private_key
      self.pk ||= ProfilesService::CreateNewPrivateKey.new.call
    end

    def generate_signing_key
      self.sk ||= ProfilesService::CreateNewSigningKey.new.call
    end

    def generate_password
      SecureRandom.urlsafe_base64(24).tap do |new_password|
        self.password_plain = new_password
        self.password = new_password
      end
    end

    def generate_backup_password
      self.backup_password = SecureRandom.hex(32)
    end

    def generate_self_peer
      ProfilesService::CreateSelfPeer.new(self).call!
    end

    def generate_self_peer!
      generate_self_peer.tap(&:save!)
    end

    def run_dev_seeds_again
      Process.spawn("bundle exec rails db:seed")
    end if Rails.env.development?
end
