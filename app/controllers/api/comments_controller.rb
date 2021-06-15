# frozen_string_literal: true

module Api
  class CommentsController < BaseController
    before_action :require_friend
    before_action :require_current_comment, only: %i(destroy)

    def index
      return create if decrypted_params[:comment].present?

      pagination = PaginationService::Paginate.new(scope: index_scope, params: params, limit: 15)

      @comments = pagination.records
    end

    def create
      @comment = CommentsService::CreateComment.new(comment_params, current_peer).call!

      render :create
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: 422
    end

    def destroy
      current_comment.destroy
      render json: encrypt_json({ ok: true })
    end

    private
      def comment_params
        @comment_params ||= decrypted_params.require(:comment).permit!
      end

      def current_comment
        @current_comment ||= scoped_comments.find_by(id: params[:id])
      end

      def require_current_comment
        render json: { error: "comment not found" }, status: 404 if current_comment.blank?
      end

      def scoped_comments
        comment.where(peer: current_peer)
      end

      def index_params
        @index_params ||= decrypted_params.require(:comments).permit(:subject_id, :subject_type)
      end

      def index_scope
        comment.includes(:comment_counter, :peer).where(
          "comment_counter.subject_id": index_params[:subject_id],
          "comment_counter.subject_type": index_params[:subject_type]
        ).order("comments.id": :desc)
      end
  end
end
