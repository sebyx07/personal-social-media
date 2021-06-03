# frozen_string_literal: true

module VirtualReactionsService
  class UnReactLocally
    class Error < StandardError; end
    attr_reader :local_cache_record, :character
    delegate :local_record, to: :@react_obj

    def initialize(local_cache_record, character)
      @local_cache_record = local_cache_record
      @character = character
      @react_obj = ReactLocally.new(local_cache_record, character)
    end

    def call!
      raise Error, "current cache reaction not found" if cache_reaction.blank?
      raise Error, "reaction not found" if current_reaction.blank?
      cache_reaction.destroy
      current_reaction.destroy
    end

    def cache_reaction
      @cache_reaction ||= CacheReaction.find_by(subject: local_record, character: character, peer: Current.peer)
    end

    def current_reaction
      @current_reaction ||= cache_reaction.reaction
    end
  end
end
