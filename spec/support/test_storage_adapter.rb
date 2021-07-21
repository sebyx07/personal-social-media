# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    FileSystemAdapters::TestAdapter.test_cleanup!
  end
end
