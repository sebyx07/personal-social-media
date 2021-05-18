# frozen_string_literal: true

class ProfilesController < ApplicationController
  def whoami
    @profile = Current.profile
    qr_code_message = ProfilePresenter.new(@profile).render.to_json

    @qr_code = EncryptionService::Sign.new.sign_message(qr_code_message)
  end
end
