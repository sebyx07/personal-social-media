# frozen_string_literal: true

return unless DeveloperService::IsEnabled.is_enabled?

Bullet.add_whitelist type: :unused_eager_loading, class_name: "RemotePost", association: :cache_reactions
Bullet.add_whitelist type: :unused_eager_loading, class_name: "RemotePost", association: :cache_comments

Bullet.add_whitelist type: :unused_eager_loading, class_name: "Post", association: :cache_reactions

# Bullet.add_whitelist type: :unused_eager_loading, class_name: "Post", association: :psm_attachments
Bullet.add_whitelist type: :unused_eager_loading, class_name: "PsmAttachment", association: :psm_cdn_files
# Bullet.add_whitelist type: :unused_eager_loading, class_name: "PsmFile", association: :psm_file_variants
Bullet.add_whitelist type: :unused_eager_loading, class_name: "PsmCdnFile", association: :cdn_storage_provider
Bullet.add_whitelist type: :unused_eager_loading, class_name: "CdnStorageProvider", association: :external_account

Bullet.add_whitelist type: :unused_eager_loading, class_name: "Comment", association: :cache_reactions
