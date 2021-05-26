# frozen_string_literal: true

module PeersService
  module Relationships
    class Unfriend
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
          peer.destroy
        end

        def make_request!
          request.run

          if !request.valid? && request.safe_retry?
            raise RequestError, "Cannot unfriend"
          end
        end
    end
  end
end
