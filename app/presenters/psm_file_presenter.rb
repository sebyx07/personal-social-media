# frozen_string_literal: true

class PsmFilePresenter
  include Memo
  def initialize(psm_file)
    @psm_file = psm_file
  end

  def render
    {
      id: @psm_file.id,
      content_type: @psm_file.content_type,
      metadata: @psm_file.metadata,
      name: @psm_file.name,
      sha_256: @psm_file.sha_256,
      variants: variants
    }
  end

  private
    def variants
      memo(:@variants) do
        variants = {}

        @psm_file.psm_file_variants.group_by(&:variant_name).map do |variant_name, grouped_variants|
          grouped_variants.each do |variant|
            variants[variant_name] ||= PsmFileVariantPresenter.new(variant).render

            variant.psm_cdn_files.each do |psm_cdn_file|
              adapter_name = psm_cdn_file.cdn_storage_provider.adapter
              variants[variant_name][:sources][adapter_name] ||= []
              variants[variant_name][:sources][adapter_name] << PsmAttachmentsService::VariantUrlResolver.new(psm_cdn_file).resolve(variant.external_file_name)
            end
          end
        end

        variants
      end
    end
end
