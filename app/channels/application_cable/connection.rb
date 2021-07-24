# frozen_string_literal: true

module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
      def find_verified_user
        ProfilesService::ControllerCurrentUser.new(request.session).call_from_action_cable.tap do |current_user|
          return reject_unauthorized_connection unless current_user
        end
      end
  end
end
