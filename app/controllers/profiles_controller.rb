# frozen_string_literal: true

class ProfilesController < ApplicationController
  def whoami
    @profile = Current.profile
    @title = @profile.name

    @qr_code = ProfilesService::ShareableQrCode.new.call

    @shared_image_file_name = "#{@profile.name.parameterize}@#{@profile.domain_name}.png"
  end

  def setup_recovery
    @title = "Finish account recovery"
    @password = Current.profile.password_plain
    redirect_to root_path, notice: "You already finished account recovery" if @password.blank?
  end

  def setup_recovery_post
    Current.profile.password_plain = nil
    Current.profile.save!

    head :ok
  end
end
