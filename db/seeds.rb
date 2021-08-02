# frozen_string_literal: true

def load_seeds(dir)
  Dir[Rails.root.join("db", dir, "**", "*.rb")].sort.each do |f|
    require f
  end
end

ApplicationRecord.transaction do
  load_seeds "dev_seeds" if Rails.env.development?
end
