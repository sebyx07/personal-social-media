# frozen_string_literal: true

module VirtualReactionsService
  class ReactLocally
    class Error < StandardError; end
    attr_reader :local_cache_record, :character, :cache_reaction

    def initialize(local_cache_record, character)
      @local_cache_record = local_cache_record
      @character = character
    end

    def call!
      CacheReaction.transaction do
        @cache_reaction = CacheReaction.find_or_initialize_by(subject: local_record, character: character, peer: Current.peer)
        next if cache_reaction.persisted?

        cache_reaction.save!
        ReactionsService::CreateReaction.new(create_params, Current.peer).call!
      end

      cache_reaction
    end

    def local_record
      return @local_record if defined? @local_record
      if local_cache_record.is_a?(RemotePost)
        @local_record = local_cache_record.local_post
      end

      raise Error, "no local record found for #{local_cache_record}" if @local_record.blank?

      @local_record
    end

    def create_params
      {
        subject_id: local_record.id,
        subject_type: local_record.class.name,
        character: character
      }
    end
  end
end
