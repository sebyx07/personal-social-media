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
    @decrypted_params = ActionController::Parameters.new(JSON.parse!(decrypted_string))
  rescue RbNaCl::CryptoError
    current_peer.mark_as_fake!
    raise Api::BaseController::InvalidParams, "invalid params"
  end

  def render_encrypted_error(error, status: 422)
    ErrorsService::LogDevError.log({ api_path: request.fullpath, error: error })
    render json: encrypt_json(error: error), status: status
  end

  def require_current_peer
    render json: { error: "peer not found" }, status: 422 if current_peer.blank?
  end

  def require_neutral
    render json: { error: "you are unfriendly" }, status: 422 unless current_peer&.neutral?
  end

  def require_friend
    render json: { error: "you are unfriendly" }, status: 422 unless current_peer&.friendly?
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
