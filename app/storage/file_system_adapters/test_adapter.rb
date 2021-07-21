# frozen_string_literal: true

module FileSystemAdapters
  class TestAdapter < BaseAdapter
    class << self
      def test_clean!
        @@cache = {} if @@cache
      end
    end

    def bootstrap
      @@cache ||= {}
    end

    def upload(file, name)
      bootstrap
      @@cache[name] = {
        file: file,
        url: "/fake-url/" + SecureRandom.hex
      }
    end

    def upload_multi(files)
      files.each do |file|
        upload(file)
      end
    end

    def remove(file)
      @@cache.delete([identify_file(file)])
    end

    def remove_multi(files)
      files.each { |f| remove(f) }
    end

    def url(file)
      fetch_file(file).tap do |f|
        raise_file_not_found(file) unless f
      end
    end

    def urls(files)
      files.map { |f| url(f) }
    end

    def exists?(file)
      fetch_file(file).present?
    end

    def multi_exists?(psm_permanent_files)
      raise NotImplementedError, "no multi_exists? defined"
    end

    def resolve_urls_for_file(variant_file_name)
      @@cache[variant_file_name][:url]
    end

    def available_free_space
      raise NotImplementedError, "no available_free_space defined"
    end

    def max_data_transfer_available
      raise NotImplementedError, "no max_data_transfer_available defined"
    end

    class << self
      def test_cleanup!
        dir = new.send(:storage_default_dir_name)
        FileUtils.rm_rf(dir)
      end if Rails.env.test?
    end

    private
      def identify_file(file)
        File.basename(file.path)
      end

      def fetch_file(file)
        @@cache[identify_file(file)]
      end
  end
end
