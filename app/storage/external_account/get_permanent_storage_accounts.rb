# frozen_string_literal: true

class ExternalAccount
  class GetPermanentStorageAccounts
    def adapters
      if (Rails.env.development? || Rails.env.test?) && accounts.blank?
        [default_test_adapter]
      end
    end

    private
      def accounts
        @accounts ||= PermanentStorageAccounts.active
      end

      def default_test_adapter
        local_file_system_adapter
      end

      def local_file_system_adapter
        FileSystemAdapters::LocalFileSystemAdapter.new
      end
  end
end
