# frozen_string_literal: true

module ActiveAdminPageLayoutOverride
  def build_active_admin_head
    within super do
      if active_admin_namespace.name == :management
        render "management/header"
      end
    end
  end

  def build_page
    within super do
      if active_admin_namespace.name == :management
        render "page/upload_manager"
      end
    end
  end
end

ActiveAdmin::Views::Pages::Base.send :prepend, ActiveAdminPageLayoutOverride
