# frozen_string_literal: true

module VirtualReactionsService
  class WhereFinder
    class Error < StandardError; end
    DEFAULT_LIMIT = 30
    attr_reader :pagination_params, :subject_type, :subject_id, :subject_type_klass

    def initialize(pagination_params, subject_type, subject_id)
      @pagination_params = pagination_params
      @subject_type = subject_type
      @subject_id = subject_id
    end

    def results
      validate_subject_type

      return handle_local if is_local_record?

      handle_remotely
    end

    private
      def handle_remotely
        json_records = VirtualReactionsService::WhereFinder::FindRemotely.new(pagination_params, cache_record).results
        json_records.map! do |json|
          VirtualReaction.new(json: json)
        end
      end

      def handle_local
        reactions = VirtualReactionsService::WhereFinder::FindLocal.new(pagination_params, cache_record).results
        reactions.to_a.map! do |reaction|
          VirtualReaction.new(reaction: reaction)
        end
      end

      def cache_record
        return @cache_record if defined? @cache_record
        @cache_record = subject_type_klass.find_by(id: subject_id)
        raise Error, "cache_record not found #{subject_type_klass}" if @cache_record.blank?
        @cache_record
      end

      def is_local_record?
        cache_record.peer_id == Current.peer.id
      end

      def validate_subject_type
        if subject_type == "RemotePost"
          @subject_type_klass = RemotePost
        end

        raise Error, "invalid subject type: #{subject_type}" if @subject_type_klass.blank?
      end
  end
end
