# frozen_string_literal: true

module ApiService
  module Peers
    class UpdateRelationship
      class Error < StandardError; end
      attr_reader :peer, :relationship, :result

      def initialize(peer, relationship)
        @peer = peer
        @relationship = relationship
      end

      def call!
        check_for_blocked!

        if relationship == "friendship_requested_by_external"
          handle_friend_request
        elsif relationship == "unfriend"
          handle_unfriend
        elsif relationship == "friend"
          handle_friend_accepted
        elsif relationship == "friendship_requested_by_external_blocked"
          handle_being_blocked
        elsif relationship == "unblock"
          handle_being_blocked
        else
          raise Error, "invalid relationship"
        end

        self
      end

      private
        def handle_friend_request
          @result = :friendship_requested_by_external
          return if peer.friend?
          add_status(result)
          remove_from_status(:imported, :stranger)
          save_peer!
        end

        def handle_unfriend
          peer.destroy
          @result = :unfriend
        end

        def handle_being_blocked
          @result = :friendship_requested_by_external_blocked
          add_status(result)
          remove_from_status(:friendship_requested_by_me, :friendship_requested_by_external)
          save_peer!
        end

        def handle_being_unblocked
          @result = :unblock
          remove_from_status(:friendship_requested_by_external_blocked)
          save_peer!
        end

        def handle_friend_accepted
          @result = :friend
          add_status(result)
          remove_from_status(:friendship_requested_by_external, :friendship_requested_by_me, :friendship_declined)
          save_peer!
        end

        def handle_friend_not_accepted
          @result = :friendship_declined
          add_status(result)
          remove_from_status(:friendship_requested_by_external)
          save_peer!
        end

        def check_for_blocked!
          raise Error, "you are blocked" if peer.full_block_by_me? && relationship != "unblock"
        end

        def save_peer!
          peer.save!
        end

        def remove_from_status(*states)
          peer.status -= states
        end

        def add_status(*states)
          peer.status += states
        end
    end
  end
end
