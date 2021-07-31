# frozen_string_literal: true

module PsmFileVariantsService
  class BuildCustomVariant
    include Memo
    attr_reader :psm_file_variant
    delegate :psm_file, :variant_name, :original_physical_file, :key, :iv, :original?, to: :psm_file_variant
    def initialize(psm_file_variant)
      @psm_file_variant = psm_file_variant
    end

    def call
      {
        encrypted_file: SafeFile.open(encrypted_file.path),
        metadata: metadata
      }
    end

    private
      def encrypted_file
        memo(:@encrypted_file) do
          EncryptionService::EncryptFile.new(transformed_file.path, "/tmp/#{SecureRandom.hex}", key, iv).call!
        end
      end

      def transformed_file
        memo(:@transformed_file) do
          next original_physical_file if original?

          if psm_file.type == :image
            BuildCustomVariantForImage.new(psm_file_variant).call
          end
        end
      end

      def metadata
        memo(:@metadata) do
          result = {}

          if psm_file.type == :image
            result = PsmFilesService::Utils::Metadata::ExtractFromImage.new(transformed_file).call
          end

          add_exif_to_result(result)
          result
        end
      end

      def add_exif_to_result(result)
        return unless original?

        exif = {}
        if psm_file.type == :image
          exif = PsmFilesService::Utils::Exif::ExtractExifFromImage.new(original_physical_file).call
        end

        return if exif.blank?
        result[:exif] = exif
      end
  end
end
