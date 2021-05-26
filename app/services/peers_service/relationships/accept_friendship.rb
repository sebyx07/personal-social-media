# frozen_string_literal: true

module PeersService
  module Relationships
    class AcceptFriendship
      attr_reader :peer, :request

      def initialize(request)
        @request = request
        @peer = request.record
      end

      def call!
        make_request!
        update_peer!
      end

      private
        def update_peer!
          peer.status -= %i(friendship_requested_by_external friendship_requested_by_me_blocked)
          peer.status << :friend
          peer.save!
        end

        def make_request!
          request.run

          if !request.valid? && request.safe_retry?
            raise RequestError, "Cannot accept friendship"
          end
        end
    end
  end
end
