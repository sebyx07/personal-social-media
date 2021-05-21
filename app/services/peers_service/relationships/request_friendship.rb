# frozen_string_literal: true

module PeersService
  module Relationships
    class RequestFriendship
      def initialize(peer)
        @peer = peer
      end

      def call!
      end
    end
  end
end
