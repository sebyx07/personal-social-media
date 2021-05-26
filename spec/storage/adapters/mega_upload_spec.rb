# frozen_string_literal: true

require "rails_helper"
require_relative "./vitual_file_context"

RSpec.describe PsmPermanentFile::Adapters::MegaUpload do
  let(:account) do
    create(:external_account, :mega_upload)
  end

  include_examples "virtual file management"
end
