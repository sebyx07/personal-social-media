# frozen_string_literal: true

module FileSystemAdapters
  class StorjAdapter < BaseS3Adapter
    def s3_endpoint
      "https://gateway.us1.storjshare.io"
    end
  end
end
