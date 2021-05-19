# frozen_string_literal: true

class ProfilesController < ApplicationController
  def whoami
    @profile = Current.profile
    @title = @profile.name

    @qr_code = ProfilesService::ShareableQrCode.new.call

    @shared_image_file_name = "#{@profile.name.parameterize}@#{@profile.domain_name}.png"
  end
end
