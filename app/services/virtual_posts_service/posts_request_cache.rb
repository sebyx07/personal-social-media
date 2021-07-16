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

      return @cache_comments = [] if grouped_queries.blank?

      query = nil
      first_query = true

      grouped_queries.each do |peer_id, gr_queries|
        remote_comment_ids = gr_queries.map { |q| q[:remote_comment_id] }
        if first_query
          query = build_query_cache_comments(peer_id, remote_comment_ids).includes(:peer)
          next first_query = false
        end
        query = query.or(build_query_cache_comments(peer_id, remote_comment_ids))
      end

      @cache_comments = query.to_a
    end

    def cache_reactions
      return @cache_reactions if defined? @cache_reactions

      queries = []
      handle_requests_with_multiple_records do |record, json|
        subject_ids = []
        characters = []
        json[:posts].map do |json_post|
          json_post[:latest_comments].map do |comment|
            subject_ids << comment[:id]
            comment[:reaction_counters].map do |reaction_counter|
              characters << reaction_counter[:character]
            end
          end
        end
        next if subject_ids.blank?

        queries << {
          peer_id: record.peer.id,
          subject_ids: subject_ids,
          characters: characters
        }
      end

      grouped_queries = queries.group_by do |query|
        query[:peer_id]
      end

      query = nil
      first_query = true

      grouped_queries.each do |peer_id, gr_queries|
        subject_ids = gr_queries.map { |gr| gr[:subject_ids] }.flatten
        characters = gr_queries.map { |gr| gr[:characters] }.flatten

        if first_query
          query = build_query_cache_reactions(peer_id, subject_ids, characters).includes(:peer)
          next first_query = false
        end
        query = query.or(build_query_cache_reactions(peer_id, subject_ids, characters))
      end
      @cache_reactions = query.to_a
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
              yield record, request.json
            end
          else
            yield request.record, request.json
          end
        end
      end

      def build_query_cache_comments(peer_id, remote_comment_ids)
        CacheComment.where(peer_id: peer_id, remote_comment_id: remote_comment_ids)
      end

      def build_query_cache_reactions(peer_id, subject_ids, characters)
        CacheReaction.where(peer_id: peer_id, subject_type: "Comment", subject_id: subject_ids, character: characters)
      end
  end
end
