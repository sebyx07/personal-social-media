# frozen_string_literal: true

require "rails_helper"
require_relative "./contexts/storage_upload_context"
require_relative "./contexts/storage_remove_context"
require_relative "./contexts/storage_download_file_context"

RSpec.describe FileSystemAdapters::StorjAdapter, skip: ENV["STORJ_SECRET_KEY"].blank? do
  let(:file) { SafeFile.open(file_path) }

  let(:account) do
    create(:external_account, :storj)
  end

  let(:filename) do
    "ca30b61c886c9a9d182dfb3d1eb83bdf"
  end
  let(:filenames) do
    %w(e9d5716f41e872f1d05b603c761686d2)
  end

  include_examples "storage upload context"
  include_examples "storage remove context"

  # context "download" do
  #   include_examples "storage download context"
  #
  #   after do
  #     next clean_download_file(subject) if subject.is_a?(File)
  #     next subject.values.each do |file|
  #       clean_download_file(file)
  #     end if subject.is_a?(Hash)
  #
  #     raise "invalid subject"
  #   end
  # end
  #
  # def clean_download_file(file)
  #   file.close
  #   File.delete(file.path)
  # end
end
