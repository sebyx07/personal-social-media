# frozen_string_literal: true

class ManagementPsmFileDecorator < ApplicationDecorator
  decorates :psm_file
  delegate_all

  def original_cdn_urls
    original.psm_cdn_files.map do |psm_cdn_file|
      PsmAttachmentsService::VariantUrlResolver.new(psm_cdn_file, original).resolve
    end
  end
end
