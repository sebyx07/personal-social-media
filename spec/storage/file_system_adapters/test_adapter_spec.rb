# frozen_string_literal: true

require "rails_helper"
require_relative "./storage_upload_context"
require_relative "./storage_remove_context"
require_relative "./storage_resolve_url_context"
require_relative "./storage_download_file_context"

RSpec.describe FileSystemAdapters::TestAdapter do
  include_examples "storage upload context"
  include_examples "storage remove context"
  include_examples "storage download context"

  let(:file) { File.open(file_path) }
  after { file.close }
end
