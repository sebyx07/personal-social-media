# frozen_string_literal: true

module ApiHelper
  def verify_psm_params_only
    head 404 if params[:nonce].blank? || params[:cypher_text].blank? || params[:public_key].blank? ||
      params[:domain_name].blank?
  end

  def decrypted_params
    return @decrypted_params if defined? @decrypted_params
    encryption_result = EncryptionService::EncryptedResult.from_json(request.parameters)
    decrypted_string = __decrypt.decrypt(encryption_result)
    @decrypted_params = JSON.parse!(decrypted_string).with_indifferent_access
  rescue RbNaCl::CryptoError
    current_peer.mark_as_fake!
    raise Api::BaseController::InvalidParams, "invalid params"
  end

  def require_current_peer
    head 403 if current_peer.blank?
  end

  def current_peer
    return @current_peer if defined? @current_peer
    @current_peer = PeersService::ControllerFindCurrent.new(params[:public_key], params[:domain_name]).call!
  end

  def encrypt_json(json = nil)
    return __encrypt.encrypt(yield.to_json).as_json if block_given?
    __encrypt.encrypt(json.to_json).as_json
  end

  private
    def __encrypt
      @__encrypt ||= EncryptionService::Encrypt.new(current_peer.public_key)
    end

    def __decrypt
      @__decrypt ||= EncryptionService::Decrypt.new(current_peer.public_key)
    end
end
