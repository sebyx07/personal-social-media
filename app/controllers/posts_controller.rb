# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :require_current_post, only: %i(update destroy show)

  def new
    @post = Post.new
  end

  def index
    @permitted_index_params = params.permit(:post_type, :peer_id, :show_from_feed_only, pagination: :from)

    @virtual_posts = VirtualPost.where(
      pagination_params: @permitted_index_params,
      post_type: @permitted_index_params[:post_type],
      peer_id: @permitted_index_params[:peer_id],
      show_from_feed_only: @permitted_index_params[:show_from_feed_only]
    ).map! do |vp|
      VirtualPostPresenter.new(vp)
    end

    render json: { posts: @virtual_posts.map(&:render) }
  end

  def create
    @post = Post.create!(create_post_params.merge(status: :ready)) # TODO REMOTE STATUS READY
    flash_success("Post created")

    redirect_to_post_unless_ready
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
    @post = current_post
  end

  def update
    @post = current_post
    current_post.update!(update_post_params)

    redirect_to_post_unless_ready
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    current_post.destroy
    flash_success("Post deleted")

    redirect_to root_path
  end

  def show
    @post = current_post
  end

  private
    def create_post_params
      params.require(:post).permit(:status, content: [:message])
    end

    def update_post_params
      create_post_params
    end

    def current_post
      @current_post ||= Post.find_by(id: params[:id])
    end

    def redirect_to_post_unless_ready
      return redirect_to root_path if @post.ready?
      redirect_to edit_post_path(@post)
    end

    def require_current_post
      return if current_post.present?

      respond_to do |f|
        f.html do
          flash_error "post not found"
          redirect_back(fallback_location: root_path)
        end

        f.json do
          render json: { error: "post not found" }, status: 404
        end
      end
    end
end
