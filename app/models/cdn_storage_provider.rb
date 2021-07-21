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
  PERMITTED_ADAPTERS = %w(FileSystemAdapters::LocalFileSystemAdapter)
  UNIQUE_ADAPTERS = %w(FileSystemAdapters::LocalFileSystemAdapter)
  PERMITTED_ADAPTERS << "FileSystemAdapters::TestAdapter" if Rails.env.test?

  belongs_to :external_account, optional: true
  attribute :used_space_bytes, :integer
  attribute :free_space_bytes, :integer
  validates :adapter, inclusion: { in: PERMITTED_ADAPTERS }
  validates :adapter, uniqueness: true, if: -> { UNIQUE_ADAPTERS.include?(adapter) }

  def upload_multi(files)
    adapter_instance.upload_multi(files)
  end

  delegate :resolve_urls_for_file, :upload, to: :adapter_instance
  def adapter_instance
    @adapter_instance ||= adapter.constantize.new
  end

  def is_local_fs?
    adapter == "FileSystemAdapters::LocalFileSystemAdapter"
  end
end
