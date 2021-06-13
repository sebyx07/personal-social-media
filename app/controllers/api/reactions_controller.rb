# frozen_string_literal: true

module Api
  class ReactionsController < BaseController
    before_action :require_friend
    before_action :require_current_reaction, only: %i(destroy)

    def index
      return create if decrypted_params[:reaction].present?

      pagination = PaginationService::Paginate.new(scope: index_scope, params: params, limit: 15)

      @reactions = pagination.records
    end

    def create
      @reaction = ReactionsService::CreateReaction.new(create_params, current_peer).call!

      render :create
    rescue ActiveRecord::RecordInvalid => e
      render json: { error: e.message }, status: 422
    end

    def destroy
      current_reaction.destroy
      render json: encrypt_json({ ok: true })
    end

    private
      def create_params
        @create_params ||= decrypted_params.require(:reaction).permit(:character, :subject_id, :subject_type)
      end

      def current_reaction
        @current_reaction ||= scoped_reactions.find_by(id: params[:id])
      end

      def require_current_reaction
        render json: { error: "reaction not found" }, status: 404 if current_reaction.blank?
      end

      def scoped_reactions
        Reaction.where(peer: current_peer)
      end

      def index_params
        @index_params ||= decrypted_params.require(:reactions).permit(:subject_id, :subject_type)
      end

      def index_scope
        Reaction.includes(:reaction_counter, :peer).where(
          "reaction_counter.subject_id": index_params[:subject_id],
          "reaction_counter.subject_type": index_params[:subject_type]
        ).order("reactions.id": :desc)
      end
  end
end
