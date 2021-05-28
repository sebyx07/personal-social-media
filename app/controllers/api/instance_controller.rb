# frozen_string_literal: true

module Api
  class InstanceController < BaseController
    def whoami
      @profile = Current.fresh_profile
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
      render json: { error: e.message }, status: 422
    end

    def sync_params
      decrypted_params[:profile]&.slice(:name, :nickname, :domain_name, :email_hexdigest)
    end
  end
end
