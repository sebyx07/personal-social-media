# frozen_string_literal: true

class ProfilePresenter
  def initialize(profile)
    @profile = profile
  end

  def render
    {
      name: @profile.name,
      nickname: @profile.name,
      email_hexdigest: @profile.email_hexdigest,
      domain_name: SettingsService::WebUrl.new.host,
      public_key: EncryptionService::EncryptedContentTransform.to_json(@profile.public_key.to_s)
    }
  end
end
