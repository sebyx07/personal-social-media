# frozen_string_literal: true

module Api
  class InstanceController < BaseController
    def whoami
      @profile = Current.profile
    end

    def sync
      PeersService::SyncPeer.new(current_peer, sync_params).call!

      whoami
      render "profiles/whoami"
    end

    def sync_params
      decrypted_params[:profile]&.slice(:name, :nickname, :domain_name, :email_hexdigest)
    end
  end
end
