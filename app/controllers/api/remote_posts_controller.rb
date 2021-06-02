# frozen_string_literal: true

module Api
  class RemotePostsController < BaseController
    before_action :require_friend
    before_action :current_post, only: %i(destroy)

    def create
      return @post = current_post if current_post.present?
      @post = RemotePost.find_or_create_by!(create_params)

      render json: encrypt_json({ ok: true })
    end

    def destroy
      current_post.destroy
      render json: encrypt_json({ ok: true })
    end

    private
      def default_scope
        RemotePost.where(peer: current_peer)
      end

      def current_post
        @current_post ||= default_scope.find_by(remote_post_id: params[:id])
      end

      def require_current_post
        render json: { error: "post not found" }, status: 404 if current_post.blank?
      end

      def create_params
        {
          remote_post_id: decrypted_params[:post][:id],
          peer: current_peer
        }
      end
  end
end
