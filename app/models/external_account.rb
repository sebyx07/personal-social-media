# frozen_string_literal: true

# == Schema Information
#
# Table name: external_accounts
#
#  id                    :bigint           not null, primary key
#  email_ciphertext      :text
#  name                  :string           not null
#  password_ciphertext   :text
#  public_key_ciphertext :text
#  secret_ciphertext     :text
#  secret_key_ciphertext :text
#  service               :string           not null
#  status                :string           default("initializing"), not null
#  usage                 :string           not null
#  username_ciphertext   :text
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class ExternalAccount < ApplicationRecord
  encrypts :email, :password, :public_key, :secret, :secret_key, :username
  str_enum :service, %i(mega_upload storj)
  str_enum :status, %i(initializing ready unavaialble)
  str_enum :usage, %i(permanent_storage cdn_storage)
  after_commit :start_bootstrap, on: :create unless Rails.env.test?
  ADAPTERS_TABLE = {
    mega_upload: {
      klass: "FileSystemAdapters::MegaUpload",
      types: %i(permanent_storage)
    },
    storj: {
      klass: "FileSystemAdapters::StorjAdapter"
    }
  }

  def dynamic_adapter
    return nil if service.blank?
    key = ADAPTERS_TABLE[service.to_sym]
    key[:klass].constantize
  end

  def start_bootstrap
    ExternalAccountsWorker::StartBootstrap.perform_async(id)
  end
end
