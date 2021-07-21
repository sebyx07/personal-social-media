# frozen_string_literal: true

module FileSystemAdapters
  class BaseAdapter
    class Error < StandardError; end
    class UploadError < StandardError; end
    class FileNotFound < StandardError; end
    attr_reader :storage_account

    def set_account(storage_account)
      @storage_account = storage_account
    end

    def bootstrap
      raise NotImplementedError, "no bootstrap defined"
    end

    def upload(file)
      raise NotImplementedError, "no upload defined"
    end

    def upload_multi(files)
      raise NotImplementedError, "no upload_multi defined"
    end

    def url(identifier)
      raise NotImplementedError, "no url defined"
    end

    def multi_urls(identifiers)
      raise NotImplementedError, "no multi_urls defined"
    end

    def remove(identifier)
      raise NotImplementedError, "no remove defined"
    end

    def remove_multi(identifiers)
      raise NotImplementedError, "no remove_multi defined"
    end

    def exists?(identifier)
      raise NotImplementedError, "no exists? defined"
    end

    def multi_exists?(identifiers)
      raise NotImplementedError, "no multi_exists? defined"
    end

    def available_free_space
      raise NotImplementedError, "no available_free_space defined"
    end

    def max_data_transfer_available
      raise NotImplementedError, "no max_data_transfer_available defined"
    end

    def resolve_urls_for_file(_)
      raise NotImplementedError, "no resolve_urls_for_file defined"
    end

    private
      def raise_adapter_error(msg, error)
        raise Error, "#{self.class.name} - #{msg} - #{error.message}"
      end

      def raise_upload_error(msg)
        raise UploadError, "#{self.class.name} - #{msg}"
      end

      def storage_default_dir_name
        "psm-do-not-delete"
      end

      def raise_file_not_found(identity)
        raise FileNotFound, "#{self.class.name} - file not found - #{identity}"
      end

      def identify_file(_)
        raise NotImplementedError, "no identify_file defined"
      end

      def fetch_file
        raise NotImplementedError, "no fetch_file defined"
      end
  end
end
