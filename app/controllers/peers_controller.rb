# frozen_string_literal: true

class PeersController < ApplicationController
  include SignaturesHelper
  before_action :require_create_permitted_params, only: :create

  def index
  end

  def show
  end

  def create
    peer = PeersService::ImportFromImage.new(create_permitted_params).call!
    peer.save!

    head :ok

  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: 422
  end

  def update
  end

  def destroy
  end

  private
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
end
