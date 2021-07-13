# frozen_string_literal: true

return unless DeveloperService::IsEnabled.is_enabled?

Bullet.add_whitelist type: :unused_eager_loading, class_name: "RemotePost", association: :cache_reactions
Bullet.add_whitelist type: :unused_eager_loading, class_name: "RemotePost", association: :cache_comments

Bullet.add_whitelist type: :unused_eager_loading, class_name: "Post", association: :cache_reactions
Bullet.add_whitelist type: :unused_eager_loading, class_name: "Comment", association: :cache_reactions
