# frozen_string_literal: true

class PeersController < ApplicationController
  include SignaturesHelper
  before_action :require_create_permitted_params, only: :create

  def index
  end

  def show
  end

  def create
    @peer = PeersService::ImportFromImage.new(create_permitted_params).call!
  end

  def update
  end

  def destroy
  end

  def require_create_permitted_params
    render json: { message: "invalid content" }, status: 422 if create_permitted_params.blank?
  end

  def create_permitted_params
    @create_permitted_params ||= signed_params.slice(:public_key, :domain_name, :verify_key)
  end
end
