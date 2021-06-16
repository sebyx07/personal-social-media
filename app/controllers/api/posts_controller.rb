# frozen_string_literal: true

module Api
  class PostsController < BaseController
    before_action :require_friend
    before_action :require_current_post, only: %i(show)
    after_action :increment_views, only: %i(show index)

    def index
      scope = default_scope.order(id: :desc)
      if decrypted_params[:ids].present?
        scope = scope.where(id: decrypted_params[:ids])
      end

      pagination = PaginationService::Paginate.new(scope: scope, params: params, limit: 15)

      @posts = pagination.records
    end

    def show
      @post = current_post
    end

    private
      def default_scope
        Post.includes(:reaction_counters, :comment_counter).ready
      end

      def current_post
        @current_post ||= default_scope.find_by(id: params[:id])
      end

      def require_current_post
        render json: { error: "post not found" }, status: 404 if current_post.blank?
      end

      def increment_views
        if @post.present?
          PostsService::IncrementViews.new(post: @post).call!
        elsif @posts.present?
          PostsService::IncrementViews.new(posts: @posts).call!
        end
      end
  end
end
