# frozen_string_literal: true

AttributesSanitizer.define_sanitizer :squish do |value|
  value.to_s.squish
end

AttributesSanitizer.define_sanitizer :no_spaces do |value|
  value.gsub(/\s/, "")
end
