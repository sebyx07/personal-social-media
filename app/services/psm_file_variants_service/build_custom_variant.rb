# frozen_string_literal: true

module PsmFileVariantsService
  class BuildCustomVariant
    include Memo
    attr_reader :psm_file_variant
    delegate :psm_file, :variant_name, :original_physical_file, :key, :iv, to: :psm_file_variant
    def initialize(psm_file_variant)
      @psm_file_variant = psm_file_variant
    end

    def call
      File.open(encrypted_file.path)
    end

    private
      def encrypted_file
        memo(:@encrypted_file) do
          EncryptionService::EncryptFile.new(transformed_file.path, "/tmp/#{SecureRandom.hex}", key, iv).call!
        end
      end

      def transformed_file
        memo(:@transformed_file) do
          next original_physical_file if variant_name.to_s == "original"

          if psm_file.type == :image
            BuildCustomVariantForImage.new(psm_file_variant).call
          end
        end
      end
  end
end
