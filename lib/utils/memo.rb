# frozen_string_literal: true

module Memo
  def memo(instance_var_name)
    return instance_variable_get(instance_var_name) if instance_variable_defined?(instance_var_name)
    yield.tap { |value| instance_variable_set(instance_var_name, value) }
  end
end
