# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:suite) do
    FileUtils.mkdir_p("/tmp/psm-upload/")
  end

  config.after(:suite) do
    FileUtils.rm_rf("/tmp/psm-upload/")
    FileSystemAdapters::LocalFileSystemAdapter.test_cleanup!
  end
end
