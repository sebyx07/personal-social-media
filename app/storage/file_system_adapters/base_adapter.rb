# frozen_string_literal: true

module FileSystemAdapters
  class BaseAdapter
    class Error < StandardError; end
    class UploadError < StandardError; end
    class FileNotFound < StandardError; end
    class NotAllowedInProduction < StandardError; end
    class InvalidUploadFile < StandardError; end
    attr_reader :storage_account

    def set_account(storage_account)
      @storage_account = storage_account
    end

    def bootstrap
      raise_not_implemented(:bootstrap)
    end

    def upload(upload_file)
      raise_not_implemented(:upload)
    end

    def upload_multi(upload_files)
      raise_not_implemented(:upload_multi)
    end

    def remove(filename)
      raise_not_implemented(:remove)
    end

    def remove_multi(filenames)
      raise_not_implemented(:remove_multi)
    end

    def exists?(filename)
      raise_not_implemented(:exists?)
    end

    def available_free_space
      raise_not_implemented(:available_free_space)
    end

    def max_data_transfer_available
      raise_not_implemented(:max_data_transfer_available)
    end

    def resolve_url_for_file(filename)
      raise_not_implemented(:resolve_urls_for_file)
    end

    def resolve_urls_for_files(filenames)
      raise_not_implemented(:resolve_urls_for_files)
    end

    def download_file(filename)
      raise_not_implemented(:download_file)
    end

    def download_files(filenames)
      raise_not_implemented(:download_files)
    end

    private
      def raise_adapter_error(msg, error)
        raise Error, "#{self.class.name} - #{msg} - #{error.message}"
      end

      def raise_upload_error(msg)
        raise UploadError, "#{self.class.name} - #{msg}"
      end

      def raise_not_implemented(method)
        raise NotImplementedError, "no #{method} implemented for #{self.class.name}"
      end

      def storage_default_dir_name
        "psm-do-not-delete"
      end

      def raise_file_not_found(filename)
        raise FileNotFound, "#{self.class.name} - file not found - #{filename}"
      end

      def identify_file(_)
        raise NotImplementedError, "no identify_file defined"
      end

      def fetch_file
        raise NotImplementedError, "no fetch_file defined"
      end

      def dont_allow_in_production
        return unless Rails.env.production?
        raise NotAllowedInProduction
      end

      def validate_upload_file(upload_file)
        raise InvalidUploadFile unless upload_file.is_a?(UploadFile)
      end
  end
end
