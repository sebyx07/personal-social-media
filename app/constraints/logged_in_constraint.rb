# frozen_string_literal: true

class LoggedInConstraint
  def self.matches?(request)
    return true unless Rails.env.production?

    ProfilesService::ControllerCurrentUser.new(request.session).call.present?
  end
end
