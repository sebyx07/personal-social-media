# frozen_string_literal: true

class VirtualReaction
  class << self
    def react_for_remote_post(remote_post_id, character)
      react_for_resource("RemotePost", remote_post_id, character)
    end

    private
      def react_for_resource(subject_type, subject_id, character)
        VirtualReactionsService::CreateForSubject.new(subject_type, subject_id, character).call
      end
  end
end
