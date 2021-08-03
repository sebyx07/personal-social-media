# frozen_string_literal: true

class PsmFileVariantPresenter
  def initialize(psm_file_variant)
    @psm_file_variant = psm_file_variant
  end

  def render
    {
      key: EncryptionService::EncryptedContentTransform.to_json(@psm_file_variant.key),
      iv: EncryptionService::EncryptedContentTransform.to_json(@psm_file_variant.iv),
    }
  end
end
