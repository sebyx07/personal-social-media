# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :require_subject_resource, only: :create
  before_action :require_subject_type, only: :create
  before_action :require_current_cache_comment, only: %i(update destroy)
  attr_reader :subject, :permitted_params

  def create
    content = VirtualCommentsService::CommentContent.new(permitted_params: permitted_params[:content])

    @cache_comment = VirtualComment.create_comment(
      subject.subject_type, subject.subject_id, content,
      permitted_params[:parent_comment_id], permitted_params[:comment_type]
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
  #
  # def index
  #   @permitted_index_params = params.permit(pagination: :from)
  #
  #   @virtual_posts = VirtualComment.where(
  #     pagination_params: @permitted_index_params,
  #     subject_type: subject_type,
  #     subject_id: subject_id,
  #     ).map! do |vp|
  #     VirtualCommentPresenter.new(vp)
  #   end
  #
  #   render json: { comments: @virtual_posts.map(&:render) }
  # end
  #

  #
  # def destroy
  #   VirtualComment.remove_react_for_resource(subject_type, subject_id, permitted_params[:character])
  #   head :ok
  # end
  #
  # def require_subject_type
  #   render json: { error: "Unknown subject" }, status: 422 if subject_type.blank?
  # end
  #
  # def subject_type
  #   return @subject_type if defined? @subject_type
  #   if params[:post_id].present?
  #     @subject_id = params[:post_id]
  #     @subject_type = "RemotePost"
  #   end
  #
  #   @subject_type
  # end
  #
  # def permitted_params
  #   @permitted_params ||= params.require(:comment).permit(:character)
  # end
end
