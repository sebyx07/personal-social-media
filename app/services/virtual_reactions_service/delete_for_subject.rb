# frozen_string_literal: true

module VirtualReactionsService
  class DeleteForSubject
    class Error < StandardError; end
    attr_reader :subject_id, :subject_type, :character
    def initialize(subject_type, subject_id, character)
      @subject_type = subject_type
      @subject_id = subject_id
      @character = character
    end

    def call
      validate_subject_type

      if local_cache_record.peer_id == Current.peer.id
        return delete_locally
      end

      delete_externally
    end

    private
      def validate_subject_type
        raise Error, "invalid subject type" unless %w(RemotePost).include?(subject_type)
      end

      def local_cache_record
        return @local_cache_record if defined? @local_cache_record
        @local_cache_record = subject_type.constantize.find_by!(id: subject_id).tap do |record|
          raise Error, "local cache record not found #{subject_type} #{subject_id}" if record.blank?
        end
      end

      def delete_locally
        UnReactLocally.new(local_cache_record, character).call!
      end

      def delete_externally
        UnReactExternally.new(local_cache_record, character).call!
      end
  end
end
