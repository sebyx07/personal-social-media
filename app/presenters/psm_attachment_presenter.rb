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
          resolved = variants[variant_name] = []

          grouped_variants.each do |variant|
            variant.psm_cdn_files.each do |psm_cdn_file|
              variant_url_resolver = PsmAttachmentsService::VariantUrlResolver.new(psm_cdn_file)
              resolved << variant_url_resolver.resolve(variant.external_file_name)
            end
          end
        end

        variants
      end
    end
end
