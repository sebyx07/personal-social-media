# frozen_string_literal: true

class VirtualReaction
  PERMITTED_DELEGATED_METHODS = %i(subject_id subject_type character created_at)
  def initialize(reaction: nil, json: nil)
    if reaction
      @presenter = VirtualReaction::PresenterForReaction.new(reaction)
    elsif json
      @presenter = VirtualReaction::PresenterForJson.new(json)
    end
  end

  delegate(*PERMITTED_DELEGATED_METHODS, to: :@presenter)
  delegate :id, :peer, to: :@presenter

  class << self
    def react_for_remote_post(remote_post_id, character, remove_reaction: false)
      subject_type = "RemotePost"

      if remove_reaction
        remove_react_for_resource(subject_type, remote_post_id, character)
      else
        react_for_resource(subject_type, remote_post_id, character)
      end
    end

    def where(pagination_params: {}, subject_type:, subject_id:)
      VirtualReactionsService::WhereFinder.new(pagination_params, subject_type, subject_id).results
    end

    def react_for_resource(subject_type, subject_id, character)
      VirtualReactionsService::CreateForSubject.new(subject_type, subject_id, character).call
    end

    def remove_react_for_resource(subject_type, subject_id, character)
      VirtualReactionsService::DeleteForSubject.new(subject_type, subject_id, character).call
    end
  end
end
