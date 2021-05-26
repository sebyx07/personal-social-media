# frozen_string_literal: true

module Peers
  class RelationshipButtonComponent < ViewComponent::Base
    attr_reader :peer
    def initialize(peer:)
      @peer = peer
    end

    def available_actions
      return @available_actions if defined? @available_actions
      @available_actions = []
      if peer.stranger? || peer.imported?
        @available_actions = [:friendship_requested_by_me]
      end

      if peer.full_block_by_me?
        @available_actions = [:unblock]
      end

      if peer.friendship_requested_by_me?
        @available_actions = [:cancel_friendship]
      end

      if peer.friendship_requested_by_external?
        @available_actions = [:friend, :friendship_requested_by_me_blocked]
      end

      if peer.friend?
        @available_actions << :unfriend
      end

      @available_actions.map! { |a| Action.new(a) }
    end

    class Action
      class Error < StandardError; end
      attr_reader :action
      ACTION_TABLE = {
        friendship_requested_by_me: {
          text: "Add friend",
          disable_with: "Adding friend.."
        },
        unblock: {
          text: "Unblock",
          disable_with: "Unblocking.."
        },
        cancel_friendship: {
          text: "Cancel friendship request",
          disable_with: "Canceling friendship.."
        },
        friend: {
          text: "Accept",
          disable_with: "Accepting friendship.."
        },
        friendship_requested_by_me_blocked: {
          text: "Decline friendship request",
          class: "bg-red-400",
          disable_with: "Declining.."
        },
        unfriend: {
          text: "Unfriend",
          class: "bg-gray-400",
          disable_with: "Deleting.."
        }
      }

      def initialize(action)
        @action = action
      end

      def action_from_table
        return @action_from_table if defined? @action_from_table
        @action_from_table = ACTION_TABLE[action].tap do |val|
          raise Error, "invalid action" if val.blank?
        end
      end

      def text
        action_from_table[:text]
      end

      def class_name
        action_from_table[:class]
      end

      def disable_with
        action_from_table[:disable_with]
      end
    end
  end
end
