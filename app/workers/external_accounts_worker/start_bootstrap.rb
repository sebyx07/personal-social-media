# frozen_string_literal: true

module ExternalAccountsWorker
  class StartBootstrap < ApplicationWorker
    attr_reader :external_account
    def perform(external_account_id)
      @external_account = ExternalAccount.find_by(id: external_account_id)
      return if external_account.blank?

      external_account.dynamic_adapter.tap do |adapter|
        i_adapter = adapter.new
        i_adapter.set_account(external_account)
        i_adapter.bootstrap
      end

      external_account.update(status: :ready)
    rescue StandardError => e
      external_account.update(status: :unavailable)
      raise e
    end
  end
end
