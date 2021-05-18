# frozen_string_literal: true

class ProfilesController < ApplicationController
  def whoami
    @profile = Current.profile
    @title = @profile.name

    qr_code_message = ProfilePresenter.new(@profile).render.to_json

    @qr_code = EncryptionService::Sign.new.sign_message(qr_code_message)

    @shared_image_file_name = "#{@profile.name.parameterize}@#{@profile.domain_name}"
  end
end
