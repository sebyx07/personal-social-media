# frozen_string_literal: true

require "rails_helper"
require_relative "./contexts/storage_upload_context"
require_relative "./contexts/storage_remove_context"
require_relative "./contexts/storage_resolve_url_context"
require_relative "./contexts/storage_download_file_context"

RSpec.describe FileSystemAdapters::TestAdapter do
  include_examples "storage upload context"
  include_examples "storage remove context"
  include_examples "storage resolve url context"
  include_examples "storage download context"

  let(:instance) { described_class.new }
  let(:file) { SafeFile.open(file_path) }
  let(:filename) { SecureRandom.hex }
  let(:filenames) { 4.times.map { SecureRandom.hex } }
end
