# frozen_string_literal: true

ActiveAdmin::ControllerAction.class_eval do
  def path
    @options[:path] ||= name
  end

  def as
    @options[:as]
  end
end

ActiveAdmin::Router.class_eval do
  def page_routes(config)
    page = config.underscored_resource_name
    router.get "/#{page}" => "#{page}#index"
    config.page_actions.each do |action|
      Array.wrap(action.http_verb).each do |verb|
        build_route(verb, "/#{page}/#{action.path}" => "#{page}##{action.name}", as: action.as)
      end
    end
  end
end
