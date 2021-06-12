# frozen_string_literal: true

return unless DeveloperService::IsEnabled.is_enabled?

Bullet.add_whitelist type: :unused_eager_loading, class_name: "RemotePost", association: :cache_reactions
