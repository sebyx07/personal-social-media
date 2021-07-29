# frozen_string_literal: true

module FileSystemAdapters
  class BaseS3Adapter < BaseAdapter
    def bootstrap
      return if bucket.present?
      client.create_bucket(bucket: storage_default_dir_name)
    rescue StandardError => e
      raise_adapter_error(e.message)
    end

    def upload(upload_file)
      validate_upload_file(upload_file)
      client.put_object(
        bucket: bucket.name,
        key: upload_file.name,
        body: upload_file.file
      )
    end

    def upload_multi(upload_files)
      upload_files.each do |upload_file|
        upload(upload_file)
      end
    end

    def remove(filename)
      bucket.objects(filename)&.delete
    end

    def remove_multi(filenames)
      filenames.each do |filename|
        remove(filename)
      end
    end

    def exists?(filename)
      @@cache.keys.include?(filename)
    end

    def resolve_url_for_file(filename)
      @@cache[filename][:url]
    end

    def resolve_urls_for_files(filenames)
      result = {}
      filenames.map do |filename|
        result[filename] = resolve_url_for_file(filename)
      end

      result
    end

    def download_file(filename)
      @@cache[filename][:file]
    end

    def download_files(filenames)
      result = {}
      filenames.each do |filename|
        result[filename] = download_file(filename)
      end

      result
    end

    def support_chunked_files?
      true
    end

    private
      def bucket
        return @bucket if @bucket.present?
        list_response = client.list_buckets
        @bucket = list_response.buckets.detect do |bucket|
          bucket.name == storage_default_dir_name
        end
      end

      def client
        return @client if defined? @client
        update_aws

        @client = Aws::S3::Client.new
      end

      def update_aws
        Aws.config.update(
          endpoint: s3_endpoint,
          access_key_id: storage_account.public_key,
          secret_access_key: storage_account.secret_key,
          force_path_style: s3_force_path_style,
          region: s3_region
        )
      end

      def s3_force_path_style
        true
      end

      def s3_region
        "us-east-1"
      end

      def s3_endpoint
      end
  end
end
