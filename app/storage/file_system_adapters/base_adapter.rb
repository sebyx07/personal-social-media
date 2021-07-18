# frozen_string_literal: true

module FileSystemAdapters
  class BaseAdapter
    class Error < StandardError; end
    class UploadError < StandardError; end
    attr_reader :storage_account

    def set_account(storage_account)
      @storage_account = storage_account
    end

    def bootstrap
      raise NotImplementedError, "no bootstrap defined"
    end

    def upload(psm_permanent_file)
      raise NotImplementedError, "no upload defined"
    end

    def upload_multi(psm_permanent_files)
      raise NotImplementedError, "no upload_multi defined"
    end

    def remove(psm_permanent_file)
      raise NotImplementedError, "no remove defined"
    end

    def remove_multi(psm_permanent_files)
      raise NotImplementedError, "no remove_multi defined"
    end

    def exists?(psm_permanent_file)
      raise NotImplementedError, "no exists? defined"
    end

    def multi_exists?(psm_permanent_files)
      raise NotImplementedError, "no multi_exists? defined"
    end

    def available_free_space
      raise NotImplementedError, "no available_free_space defined"
    end

    def max_data_transfer_available
      raise NotImplementedError, "no max_data_transfer_available defined"
    end

    private
      def raise_adapter_error(msg, error)
        raise Error, "#{self.class.name} - #{msg} - #{error.message}"
      end

      def raise_upload_error(msg)
        raise UploadError, "#{self.class.name} - #{}"
      end

      def storage_default_dir_name
        "psm-do-not-delete"
      end
  end
end
