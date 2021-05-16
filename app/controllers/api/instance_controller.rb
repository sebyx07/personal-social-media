# frozen_string_literal: true

module Api
  class InstanceController < BaseController
    def whoami
      @profile = Current.profile
    end
  end
end
