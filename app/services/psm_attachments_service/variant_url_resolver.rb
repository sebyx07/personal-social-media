# frozen_string_literal: true

module PsmAttachmentsService
  class VariantUrlResolver
    attr_reader :psm_cdn_file
    delegate :cdn_storage_provider, to: :psm_cdn_file
    def initialize(psm_cdn_file)
      @psm_cdn_file = psm_cdn_file
    end

    def resolve(external_file_name)
      {
        urls: cdn_storage_provider.resolve_urls_for_file(external_file_name),
      }
    end
  end
end
