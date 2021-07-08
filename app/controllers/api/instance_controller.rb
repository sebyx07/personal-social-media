# frozen_string_literal: true

module Api
  class InstanceController < BaseController
    skip_before_action :require_current_peer, only: :update_relationship
    before_action :require_current_peer_even_blocked_by_me, only: :update_relationship

    def whoami
      verify_key = decrypted_params.permit(peer: { verify_key: [] })[:verify_key]
      PeersService::SetVerifyKeyOnWhoami.new(current_peer, verify_key).call!

      @profile = Current.profile
    end

    def sync
      PeersService::SyncPeer.new(current_peer, sync_params).call!

      whoami
      render :whoami
    end

    def update_relationship
      relationship = decrypted_params[:relationship]
      service = ApiService::Peers::UpdateRelationship.new(current_peer, relationship).call!

      render json: encrypt_json({ relationship: service.result })
    rescue ApiService::Peers::UpdateRelationship::Error => e
      render json: encrypt_json({ error: e.message }), status: 422
    end

    def sync_params
      decrypted_params.require(:profile).permit(:name, :nickname, :domain_name, :email_hexdigest)
    end

    def require_current_peer_even_blocked_by_me
      render json: { error: "you are unfriendly" }, status: 422 unless current_peer_even_blocked_by_me
    end

    def current_peer_even_blocked_by_me
      return @current_peer_even_blocked_by_me if defined? @current_peer_even_blocked_by_me
      @current_peer_even_blocked_by_me = PeersService::ControllerFindCurrent.new(params[:public_key], params[:domain_name]).any_peer_call!
      @current_peer = @current_peer_even_blocked_by_me
    end
  end
end
