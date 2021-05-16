# frozen_string_literal: true

module ApiHelper
  def verify_psm_params_only
    head 404 if unsafe_params[:nonce].blank? || unsafe_params[:cypher_text].blank? || unsafe_params[:public_key].blank? ||
      unsafe_params[:domain_name].blank?
  end

  def params
    return @psm_params if defined? @psm_params
    encryption_result = EncryptionService::EncryptedResult.from_json(request.parameters)
    json = EncryptionService::Decrypt.new(params[:public_key]).decrypt(encryption_result)
    @psm_params = json.with_indifferent_access
  rescue RbNaCl::CryptoError
    current_peer.mark_as_fake!
    raise Api::BaseController::InvalidParams, "invalid params"
  end

  def require_current_peer
    head 403 if current_peer.blank?
  end

  def current_peer
    return @current_peer if defined? @current_peer
    @current_peer = PeersService::ControllerFindCurrent.new(unsafe_params[:public_key], unsafe_params[:domain_name]).call!
  end
end
