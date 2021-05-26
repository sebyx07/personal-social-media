# frozen_string_literal: true

module PeersService
  class RelationshipStatus
    UNFRIENDLY = %i(full_block_by_me full_block_by_external fake)

    class << self
      def scope_for_sync(query)
        query.with_any_status(:friend, :friendship_requested_by_external).without_status(UNFRIENDLY)
      end

      def scope_safe(query)
        query.without_status(UNFRIENDLY)
      end

      def scope_including_blocked_by_me(query)
        query.without_status(%i(full_block_by_external fake))
      end
    end
  end
end
