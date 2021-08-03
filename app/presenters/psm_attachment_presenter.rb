# frozen_string_literal: true

class PsmAttachmentPresenter
  include Memo
  attr_reader :attachment
  def initialize(psm_attachment)
    @attachment = psm_attachment
  end

  def render_inside_content
    {
      id: @attachment.id,
      variants: variants
    }
  end

  private
    def variants
      memo(:@variants) do
        variants = {}

        @attachment.psm_file_variants.group_by(&:variant_name).map do |variant_name, grouped_variants|
          grouped_variants.each do |variant|
            variants[variant_name] ||= PsmFileVariantPresenter.new(variant).render
            variants[variant_name][:sources] ||= {}

            variant.psm_cdn_files.each do |psm_cdn_file|
              adapter_name = psm_cdn_file.cdn_storage_provider.adapter
              variants[variant_name][:sources][adapter_name] = PsmAttachmentsService::VariantUrlResolver.new(psm_cdn_file).resolve(variant.external_file_name)
            end
          end
        end

        variants
      end
    end
end
