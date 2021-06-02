# frozen_string_literal: true

module SyncService
  class SyncPeersRegularly
    attr_reader :current_requests
    def call!
      query.each do |peers|
        build_requests(peers)
        run_requests
        handle_valid_requests
      end
    end

    private
      def query
        @query ||= PeersService::RelationshipStatus.scope_for_sync(Peer).in_batches(of: batch_size)
      end

      def batch_size
        HttpService::ApiClientBatch::AR_BATCH_SIZE
      end

      def build_requests(peers)
        @current_requests = peers.map { |p| build_request(p) }
      end

      def build_request(peer)
        HttpService::ApiClient.new(url: peer.api_url("/instance/sync"), method: :post, body: sync_body, record: peer, peer: peer)
      end

      def run_requests
        client_batch = HttpService::ApiClientBatch.new(requests: current_requests)
        client_batch.run
      end

      def sync_body
        return @sync_body if defined? @sync_body
        p = Current.profile
        @sync_body = {
          profile: {
            name: p.name,
            nickname: p.nickname,
            domain_name: p.domain_name,
            email_hexdigest: p.email_hexdigest
          }
        }
      end

      def handle_valid_requests
        requests = current_requests.select { |r| r.valid? }

        requests.each do |req|
          req.record.update!(extract_update_params(req.json))
        end
      end

      def extract_update_params(json)
        return {} if json[:profile].blank?
        attributes = {
          server_last_seen_at: Time.zone.now,
        }

        from_request_attributes = json[:profile].slice(:name, :nickname, :email_hexdigest, :domain_name)
        from_request_attributes.merge!(attributes)
      end
  end
end
