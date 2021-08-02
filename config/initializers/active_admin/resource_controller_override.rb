# frozen_string_literal: true

ActiveAdmin::ResourceController.class_eval do
  helper_method :scoped_collection
end
