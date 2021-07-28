# frozen_string_literal: true

module FileSystemAdapters
  class LocalFileSystemAdapter < BaseAdapter
    def bootstrap
      return if defined? @boostrap
      @boostrap = true
      return if File.directory?(storage_default_dir_name)
      FileUtils.mkdir_p(storage_default_dir_name)
    end

    def upload(upload_file, call_bootstrap: true)
      bootstrap if call_bootstrap
      validate_upload_file(upload_file)

      FileUtils.cp(upload_file.file.path, filename_to_path(upload_file.name))
    end

    def upload_multi(upload_files)
      bootstrap

      upload_files.each do |upload_file|
        upload(upload_file, call_bootstrap: false)
      end
    end

    def remove(filename)
      File.delete(filename_to_path(filename))
    end

    def remove_multi(filenames)
      paths = filenames.map { |f| filename_to_path(f) }
      FileUtils.rm(paths)
    end

    def exists?(filename)
      File.exist?(filename_to_path(filename))
    end

    def resolve_url_for_file(filename)
      "/#{upload_dir_path}/#{filename}"
    end

    def resolve_urls_for_files(filenames)
      result = {}
      filenames.map do |filename|
        result[filename] = resolve_url_for_file(filename)
      end

      result
    end

    def download_file(filename)
      File.open(filename_to_path(filename))
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

    class << self
      def test_cleanup!
        dir = new.send(:storage_default_dir_name)
        FileUtils.rm_rf(dir)
      end if Rails.env.test?
    end

    private
      def storage_default_dir_name
        return @storage_default_dir_name if defined? @storage_default_dir_name
        dir = upload_dir_path
        if Rails.env.test?
          dir = "tmp/" + dir + "/test"
        elsif Rails.env.development?
          dir = "public/" + dir + "/dev"
        else
          dir = "~/." + dir
        end

        @storage_default_dir_name = dir
      end

      def upload_dir_path
        "psm-do-not-delete/uploads"
      end

      def filename_to_path(filename)
        storage_default_dir_name + "/" + filename
      end
  end
end
