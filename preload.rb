# frozen_string_literal: true

require_relative "config/environment"

if GC.respond_to?(:compact)
  GC.compact
end
