# frozen_string_literal: true

require "rails_helper"
require_relative "./storage_upload_context"
require_relative "./storage_remove_context"
require_relative "./storage_resolve_url_context"
require_relative "./storage_download_file_context"

RSpec.describe FileSystemAdapters::LocalFileSystemAdapter do
  include_examples "storage upload context"
  include_examples "storage remove context"
  include_examples "storage download context"

  def file
    output = "/tmp/#{SecureRandom.hex}"
    FileUtils.cp(file_path, output)
    File.new(output).tap do |f|
      f.close
    end
  end
end
