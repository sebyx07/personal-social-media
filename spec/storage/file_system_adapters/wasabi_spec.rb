# frozen_string_literal: true

require "rails_helper"
require_relative "./contexts/storage_upload_context"
require_relative "./contexts/storage_remove_context"
require_relative "./contexts/storage_download_file_context"

RSpec.describe FileSystemAdapters::WasabiAdapter, skip: ENV["WASABI_SECRET_KEY"].blank? do
  let(:file) { SafeFile.open(file_path) }

  let(:account) do
    create(:external_account, :wasabi)
  end

  let(:filename) do
    "ca30b61c886c9a9d182dfb3d1eb83bdf"
  end
  let(:filenames) do
    %w(e9d5716f41e872f1d05b603c761686d2 a7059995a85a27cccf762db2f62d3121 cda88da0cd61ff24cf5e50ece716ce7a 9609815c081b9f3a58b93fdc08077b5a)
  end

  include_examples "storage upload context"
  include_examples "storage remove context"
  include_examples "storage download context"
end
