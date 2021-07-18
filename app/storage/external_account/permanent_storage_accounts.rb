# frozen_string_literal: true

class ExternalAccount
  class PermanentStorageAccounts
    class << self
      def active
        ExternalAccount.where(usage: :permanent_storage, status: :ready)
      end
    end
  end
end
