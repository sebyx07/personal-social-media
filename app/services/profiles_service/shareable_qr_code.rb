# frozen_string_literal: true

module ProfilesService
  class ShareableQrCode
    attr_reader :profile
    def initialize
      @profile = Current.fresh_profile
    end

    def call
      qr_code_message = ProfilePresenter.new(profile).render.to_json
      EncryptionService::Sign.new.sign_message(qr_code_message)
    end
  end
end
