# frozen_string_literal: true

module ReactionsService
  class CreateReaction
    attr_reader :create_params, :current_peer
    def initialize(create_params, current_peer)
      @create_params = create_params
      @current_peer = current_peer
    end

    def call!
      reaction
    end

    def reaction_counter
      @reaction_counter ||= ReactionCounter.find_or_create_by!(
        subject_type: create_params[:subject_type],
        subject_id: create_params[:subject_id],
        character: create_params[:character],
      )
    end

    def reaction
      @reaction ||= Reaction.find_or_create_by!(
        reaction_counter: reaction_counter,
        peer: current_peer
      )
    end
  end
end
