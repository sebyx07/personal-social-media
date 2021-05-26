# frozen_string_literal: true

class PeersController < ApplicationController
  include SignaturesHelper
  before_action :require_create_permitted_params, only: :create
  before_action :require_peer, only: %i(show update destroy)

  def index
  end

  def show
    @peer = current_peer
  end

  def create
    peer = PeersService::ImportFromImage.new(create_permitted_params).call!
    peer.save!

    @peer = peer
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: 422
  end

  def update
    if permitted_update_params[:relationship].present?
      PeersService::UpdatePeerRelationship.new(current_peer, permitted_update_params[:relationship]).call!
    end
    @peer = current_peer

    respond_to do |f|
      f.html { redirect_to peer_path(@peer), notice: "Saved" }
      f.json
    end
  rescue PeersService::UpdatePeerRelationship::Error, PeersService::UpdatePeerRelationship::RequestError => e
    respond_to do |f|
      f.html { redirect_to peer_path(peer), notice: e.message }
      f.json do
        render json: { error: e.message }, status: 422
      end
    end
  end

  def destroy
    PeersService::UpdatePeerRelationship.new(current_peer, :unfriend).call!
    head :ok
  end

  private
    def permitted_update_params
      @permitted_update_params ||= params.require(:peer).permit(:relationship)
    end

    def require_create_permitted_params
      render json: { message: "invalid content" }, status: 422 if create_permitted_params.blank?
    end

    def create_permitted_params
      return @create_permitted_params if @create_permitted_params.present?
      @create_permitted_params = signed_params.slice(:domain_name, :verify_key).tap do |create_params|
        create_params[:public_key] = EncryptionService::EncryptedContentTransform.to_str(signed_params[:public_key])
        create_params[:verify_key] = verify_key
      end
    end

    def current_peer
      @current_peer ||= PeersService::RelationshipStatus.scope_including_blocked_by_me(Peer).find_by(id: params[:id])
    end

    def require_peer
      return if current_peer.present?
      error_message = "Peer not found"

      respond_to do |f|
        f.html do
          flash[:error] = error_message
          redirect_back(fallback_location: peers_path)
        end
        f.json do
          render json: { error: error_message }, status: 404
        end
      end
    end
end
