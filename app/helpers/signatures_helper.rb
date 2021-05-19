# frozen_string_literal: true

module SignaturesHelper
  def signed_params
    return @signed_params if defined? @signed_params
    if params[:message].blank? || params[:signature].blank? || params[:verify_key].blank?
      return @signed_params = {}
    end

    signed_result = EncryptionService::SignedResult.from_json(params.permit!)

    unless EncryptionService::VerifySignature.new(verify_key).verify(signed_result)
      return @signed_params = {}
    end

    @signed_params = JSON.parse!(params[:message]).with_indifferent_access

  rescue JSON::ParserError
    @signed_params = {}
  end

  def verify_key
    @verify_key ||= EncryptionService::EncryptedContentTransform.to_str(params[:verify_key])
  end
end
