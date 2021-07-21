# frozen_string_literal: true

ActiveAdmin.register Setting, namespace: :management do
  actions :index, :edit, :update
  menu url: -> { edit_management_setting_path(Current.settings) }, priority: 99

  controller do
    def index
      redirect_to edit_management_setting_path(Current.settings)
    end

    def current_settings
      @current_settings ||= Current.settings
    end
  end
end
