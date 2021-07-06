# frozen_string_literal: true

module VirtualPostsService
  class RemoteRequestsCache
    attr_reader :requests
    def initialize
      @requests = []
    end

    def sub_peers
      return @sub_peers if defined? @sub_peers
      sub_peers_verify_keys = []
      requests.each do |request|
        request.json[:posts].each do |post|
          post[:latest_comments].each do |comment|
            verify_key = get_verify_key_from_json(comment.dig(:peer, :verify_key))
            sub_peers_verify_keys << verify_key
            comment[:peer][:str_verify_key] = verify_key
          end
        end
      end

      return @sub_peers = [] if sub_peers_verify_keys.blank?
      @sub_peers = Peer.where(verify_key: sub_peers_verify_keys.uniq)
    end

    private
      def get_verify_key_from_json(json)
        EncryptionService::EncryptedContentTransform.to_str(json)
      end
  end
end
