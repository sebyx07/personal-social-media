# frozen_string_literal: true

module Page
  class UserDropdownComponent < ViewComponent::Base
    attr_reader :current_user, :width
    def initialize(current_user:, width:)
      @current_user = current_user
      @width = width
    end
  end
end
