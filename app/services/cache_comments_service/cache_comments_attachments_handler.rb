# frozen_string_literal: true

module CacheCommentsService
  class CacheCommentsAttachmentsHandler
    def accepted_file_types
      %i(images videos simple)
    end
  end
end
