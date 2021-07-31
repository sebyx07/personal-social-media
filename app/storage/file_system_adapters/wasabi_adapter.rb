# frozen_string_literal: true

module FileSystemAdapters
  class WasabiAdapter < BaseS3Adapter
    def s3_endpoint
      "https://s3.us-east-1.wasabisys.com"
    end

    def s3_force_path_style
      false
    end
  end
end
