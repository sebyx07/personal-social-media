# frozen_string_literal: true

RSpec.configure do |config|
  config.after(:each) do
    SafeFile.close_opened_files!
    SafeTempfile.clean_safe_temp_files!
  end
end
