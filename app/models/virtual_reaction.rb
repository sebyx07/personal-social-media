# frozen_string_literal: true

class VirtualReaction
  class << self
    def react_for_remote_post(remote_post_id, character, remove_reaction: false)
      subject_type = "RemotePost"

      if remove_reaction
        remove_react_for_resource(subject_type, remote_post_id, character)
      else
        react_for_resource(subject_type, remote_post_id, character)
      end
    end

    # def where(pagination_params: nil, subject_type:)
    #   VirtualPostsService::WhereFinder.new(pagination_params, post_type: post_type, peer_id: peer_id).results
    # end

    def react_for_resource(subject_type, subject_id, character)
      VirtualReactionsService::CreateForSubject.new(subject_type, subject_id, character).call
    end

    def remove_react_for_resource(subject_type, subject_id, character)
      VirtualReactionsService::DeleteForSubject.new(subject_type, subject_id, character).call
    end
  end
end
