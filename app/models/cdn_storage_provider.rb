# frozen_string_literal: true

# == Schema Information
#
# Table name: cdn_storage_providers
#
#  id                  :bigint           not null, primary key
#  adapter             :string           not null
#  enabled             :boolean          default(TRUE), not null
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
  class << self
    delegate :permitted_adapters, :unique_adapters, to: :cdn_adapters
    def cdn_adapters
      CdnStorageProviderService::CdnAdapters.new
    end
  end

  belongs_to :external_account, optional: true
  attribute :used_space_bytes, :integer
  attribute :free_space_bytes, :integer
  validates :adapter, inclusion: { in: permitted_adapters }
  validates :adapter, uniqueness: true, if: -> do
    self.class.unique_adapters.include?(adapter) && self.class.where(adapter: adapter).count > 1
  end

  def upload_multi(files)
    adapter_instance.upload_multi(files)
  end

  delegate :resolve_url_for_file, :upload, to: :adapter_instance
  def adapter_instance
    @adapter_instance ||= adapter.constantize.new
  end

  def is_local_fs?
    adapter == "FileSystemAdapters::LocalFileSystemAdapter"
  end
end
