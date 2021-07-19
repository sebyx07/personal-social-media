# frozen_string_literal: true

# == Schema Information
#
# Table name: cdn_storage_providers
#
#  id                  :bigint           not null, primary key
#  adapter             :string           not null
#  enabled             :boolean          default(FALSE), not null
#  free_space_bytes    :string           default(0), not null
#  used_space_bytes    :string           default(0), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  external_account_id :bigint
#
# Indexes
#
#  index_cdn_storage_providers_on_external_account_id  (external_account_id)
#
# Foreign Keys
#
#  fk_rails_...  (external_account_id => external_accounts.id)
#
class CdnStorageProvider < ApplicationRecord
  belongs_to :external_account, optional: true
  attribute :used_space_bytes, :integer
  attribute :free_space_bytes, :integer
  validate :validate_adapter

  def upload(file)
    adapter_instance.upload(file)
  end

  def upload_multi(files)
    adapter_instance.upload_multi(files)
  end

  def adapter_instance
    @adapter_instance ||= adapter.constantize.new
  end

  private
    def validate_adapter
      adapter.constantize
    rescue NameError => e
      errors.add(:adapter, e.message)
    end
end
