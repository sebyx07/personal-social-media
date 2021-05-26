# frozen_string_literal: true

class ExternalAccount
  class StorageAccount
    class << self
      def current
        ExternalAccount.find_by(usage: :permanent_storage, status: :ready)
      end
    end
  end
end
