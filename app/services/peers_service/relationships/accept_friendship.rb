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
        accept_friendship_if_dev do
          make_request!
        end
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
            raise UpdatePeerRelationship::RequestError, "Cannot accept friendship"
          end
        end

        def accept_friendship_if_dev
          return yield unless Rails.env.production?
          return yield unless DeveloperService::IsEnabled.is_enabled?
          yield unless peer.domain_name.match?(/^localhost(:\d+)?/)
        end
    end
  end
end
