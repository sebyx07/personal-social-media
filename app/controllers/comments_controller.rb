# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :require_remote_post, only: %i(index create)
  before_action :require_subject_resource, only: %i(create)
  before_action :require_subject_type, only: %i(create)
  before_action :require_subject_index, only: :index
  before_action :require_current_cache_comment, only: %i(update destroy)
  attr_reader :subject, :permitted_params

  def index
    @permitted_index_params = params.permit(pagination: :from)
    @virtual_posts = VirtualComment.where(
      pagination_params: @permitted_index_params, subject: subject, parent_comment_id: permitted_params[:parent_comment_id],
      remote_post: remote_post
    ).map! do |vp|
      VirtualCommentPresenter.new(vp)
    end

    render json: { comments: @virtual_posts.map(&:render) }
  end

  def create
    content = VirtualCommentsService::CommentContent.new(permitted_params: permitted_params)

    @cache_comment = VirtualComment.create_comment(
      subject.subject_type, subject.subject_id, content,
      permitted_params[:parent_comment_id], permitted_params[:comment_type],
      remote_post: remote_post
    )
  end

  def update
    @permitted_params = params.require(:comment).permit(:comment_type,
      *VirtualCommentsService::CommentContent::PERMITTED_CONTENT_ATTRIBUTES
    )
    content = VirtualCommentsService::CommentContent.new(permitted_params: permitted_params)

    @cache_comment = VirtualComment.update_comment(current_cache_comment, content, permitted_params[:comment_type])
  end

  def destroy
    VirtualComment.remove_comment(current_cache_comment)
    render json: { ok: true }
  end

  private
    def require_subject_resource
      @permitted_params = params.require(:comment).permit(
        :subject_id, :subject_type, :parent_comment_id, :comment_type,
        *VirtualCommentsService::CommentContent::PERMITTED_CONTENT_ATTRIBUTES
      )
      @subject = VirtualSubject.new(@permitted_params)
      render json: { error: "Invalid subject" }, status: 422 unless subject.valid?
    end

    def require_subject_type
      return if %w(RemotePost).include?(subject.subject_type)

      render json: { error: "Invalid subject_type" }, status: 422
    end

    def current_cache_comment
      @current_cache_comment ||= CacheComment.find_by(id: params[:id])
    end

    def require_current_cache_comment
      render json: { error: "cache comment not found" }, status: 404 if current_cache_comment.blank?
    end

    def require_subject_index
      @permitted_params = params.permit(:subject_id, :subject_type, :parent_comment_id, pagination: :from)
      @subject = VirtualSubject.new(permitted_params)

      unless %w(RemotePost).include?(subject.subject_type)
        return render json: { error: "Invalid subject_type" }, status: 422
      end

      render json: { error: "subject not found" }, status: 404 if subject.blank?
    end

    def remote_post
      @remote_post ||= RemotePost.find_by(id: params[:post_id])
    end

    def require_remote_post
      render json: { error: "Remote Post not found" }, status: 404 if remote_post.blank?
    end
end
