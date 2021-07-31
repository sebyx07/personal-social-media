# frozen_string_literal: true

RSpec.configure do |config|
  config.after(:each) do
    SafeFile.close_opened_files!
  end
end
