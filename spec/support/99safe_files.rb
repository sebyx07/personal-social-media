# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    tmp_bad_files = (Dir.glob("/tmp/*") - %w(/tmp/psm-upload))
    FileUtils.rm_rf(tmp_bad_files)
  end

  config.after(:each) do
    SafeFile.close_opened_files!
    SafeTempfile.clean_safe_temp_files!
    rack_temp_file_matcher = /\/tmp\/\d{6}/

    tmp_bad_files = (Dir.glob("/tmp/*") - %w(/tmp/psm-upload)).select do |file|
      next false if file.match?(rack_temp_file_matcher)
    end

    next if tmp_bad_files.blank?

    p tmp_bad_files
    expect(tmp_bad_files).to be_blank, "Your tests has temp files left overs"
  end

  config.after(:suite) do
    SafeFile.close_opened_files!
    SafeTempfile.clean_safe_temp_files!
  end
end

at_exit do
  SafeFile.close_opened_files!
  SafeTempfile.clean_safe_temp_files!
end
