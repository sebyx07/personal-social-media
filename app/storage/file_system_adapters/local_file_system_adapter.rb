# frozen_string_literal: true

module FileSystemAdapters
  class LocalFileSystemAdapter < BaseAdapter
    def bootstrap
      return if defined? @boostrap
      @boostrap = true
      return if File.directory?(storage_default_dir_name)
      FileUtils.mkdir_p(storage_default_dir_name)
    end

    def upload(file)
      bootstrap
      file.close
      raise_upload_error("no physical_file") if file.blank?

      output_path = storage_default_dir_name + "/" + File.basename(file)
      FileUtils.mv(file.path, output_path)
    end

    def upload_multi(psm_permanent_files)
      psm_permanent_files.each do |psm_permanent_file|
        upload(psm_permanent_file)
      end
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

    class << self
      def test_cleanup!
        dir = new.send(:storage_default_dir_name)
        FileUtils.rm_rf(dir)
      end if Rails.env.test?
    end

    private
      def raise_adapter_error(msg, error)
        raise Error, "#{self.class.name} - #{msg} - #{error.message}"
      end

      def raise_upload_error(msg)
        raise UploadError, "#{self.class.name} - #{}"
      end

      def storage_default_dir_name
        return @storage_default_dir_name if defined? @storage_default_dir_name
        dir = "psm-do-not-delete/uploads"
        if Rails.env.test?
          dir = "tmp/" + dir + "/test"
        elsif Rails.env.development?
          dir = "tmp/" + dir + "/dev"
        else
          dir = "~/." + dir
        end

        @storage_default_dir_name = dir
      end
  end
end
