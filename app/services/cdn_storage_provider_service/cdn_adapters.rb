# frozen_string_literal: true

module CdnStorageProviderService
  class CdnAdapters
    def permitted_adapters
      return production_adapters + dev_adapters if Rails.env.development?
      return production_adapters + test_adapters if Rails.env.test?

      production_adapters
    end

    def translated_permitted_adapters
      permitted_adapters.map do |adapter|
        full_name = [I18n.t("storage_adapters.#{adapter}.name"), I18n.t("storage_adapters.#{adapter}.description")].join(" ")

        [full_name, adapter]
      end
    end

    def unique_adapters
      return dev_adapters if Rails.env.development?
      return [] if Rails.env.test?
    end

    private
      def production_adapters
        %w()
      end

      def dev_adapters
        %w(FileSystemAdapters::LocalFileSystemAdapter)
      end

      def test_adapters
        dev_adapters + %w(FileSystemAdapters::TestAdapter)
      end
  end
end
