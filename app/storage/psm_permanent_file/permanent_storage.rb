# frozen_string_literal: true

class PsmPermanentFile
  class PermanentStorage
    attr_reader :adapter, :storage_account

    def initialize(storage_account)
      @adapter = MegaUpload.new
      @storage_account = storage_account
      @adapter.set_account(storage_account)
    end

    def save!(*files)
    end
  end
end
