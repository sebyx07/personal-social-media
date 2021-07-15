# frozen_string_literal: true

module VirtualPostsService
  class PostsRequestCache
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

    def cache_comments
      return @cache_comments if defined? @cache_comments
      queries = []

      requests.each do |request|
        request.json[:posts].each do |post|
          post[:latest_comments].each do |comment|
            queries << {
              peer_id: request.peer.id,
              remote_comment_id: comment[:id]
            }
          end
        end
      end

      grouped_queries = queries.group_by do |query|
        query[:peer_id]
      end

      @cache_comments = grouped_queries.map do |peer_id, gr_queries|
        remote_comment_ids = gr_queries.map { |q| q[:remote_comment_id] }
        CacheComment.includes(:peer).where(peer_id: peer_id, remote_comment_id: remote_comment_ids).to_a
      end.flatten
    end

    def cache_reactions
      return @cache_reactions if defined? @cache_reactions

      queries = []
      handle_requests_with_multiple_records do |record|
        queries << {
          peer_id: record.peer_id,
          remote_id: get_remote_id_for_record(record),
          subject_type: record.class.name
        }
      end
      grouped_queries = queries.group_by do |query|
        query[:subject_type]
      end

      @cache_reactions = grouped_queries.map do |subject_type, gr_queries|
        peer_ids = gr_queries.map { |q| q[:peer_id] }
        remote_ids = gr_queries.map { |q| q[:remote_id] }
        CacheReaction.includes(:peer).where(subject_type: subject_type, peer_id: peer_ids, subject_id: remote_ids).to_a
      end.flatten
    end

    private
      def get_verify_key_from_json(json)
        EncryptionService::EncryptedContentTransform.to_str(json)
      end

      def get_remote_id_for_record(record)
        if record.is_a?(RemotePost)
          record.remote_post_id
        end
      end

      def handle_requests_with_multiple_records
        requests.each do |request|
          if request.record.respond_to?(:each)
            request.record.each do |record|
              yield record
            end
          else
            yield request.record
          end
        end
      end
  end
end
