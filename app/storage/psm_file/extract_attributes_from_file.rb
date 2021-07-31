# frozen_string_literal: true

class PsmFile
  class ExtractAttributesFromFile
    attr_reader :physical_file
    def initialize(physical_file)
      @physical_file = physical_file
    end

    def attributes
      {
        name: name,
        content_type: content_type,
        metadata: metadata,
        sha_256: PsmFilesService::Utils::ComputeFileSha256.new(physical_file).call
      }
    end

    private
      def name
        SafeFile.basename(physical_file.path)
      end

      def content_type
        Marcel::MimeType.for(physical_file)
      end

      def metadata
        {}
      end
  end
end
