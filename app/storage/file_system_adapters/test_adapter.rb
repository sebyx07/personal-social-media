# frozen_string_literal: true

module FileSystemAdapters
  class TestAdapter < BaseAdapter
    def bootstrap
      @@cache ||= {}
    end

    def upload(upload_file)
      validate_upload_file(upload_file)
      bootstrap
      @@cache[upload_file.name] = {
        file: upload_file.file,
        url: "/fake-url/" + SecureRandom.hex
      }
    end

    def upload_multi(upload_files)
      upload_files.each { |upload| validate_upload_file(upload) }

      upload_files.each do |upload_file|
        upload(upload_file)
      end
    end

    def remove(filename)
      @@cache.delete(filename)
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

    class << self
      def test_cleanup!
        @@cache = {}
      end if Rails.env.test?
    end
  end
end
