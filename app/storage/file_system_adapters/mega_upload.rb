# frozen_string_literal: true

module FileSystemAdapters
  class MegaUpload < BaseAdapter
    def bootstrap
      client.root.create_folder(storage_default_dir_name)
    end

    def upload(upload_file)
      validate_upload_file(upload_file)

      folder.upload(upload_file.file.path, filename: upload_file.name)
    end

    def upload_multi(upload_files)
      upload_files.each do |upload_file|
        upload(upload_file)
      end
    end

    def exists?(filename)
      !get_file(filename).nil?
    end

    def remove(filename)
      get_all_files_by_name(filename).each do |file|
        file.delete
        folder_files.delete(file)
      end
    end

    def remove_multi(filenames)
      filenames.each do |filename|
        remove(filename)
      end
    end

    def download_file(filename)
      return nil unless exists?(filename)
      download_file_name = SecureRandom.hex(50)
      file_path = "/tmp/#{download_file_name}"
      FileUtils.rm_rf("/tmp/*")
      get_file(filename).download("/tmp", output_name: download_file_name)

      File.open(file_path, "rb")
    end

    def download_files(filenames)
      result = {}
      filenames.each do |filename|
        result[filename] = download_file(filename)
      end

      result
    end

    private
      def client
        check_storage_account!
        return @client if defined? @client
        @client = Rmega.login(storage_account.email, storage_account.password)
      rescue Rmega::ServerError => e
        raise_adapter_error("invalid login", e)
      end

      def folder
        @folder ||= client.nodes.find do |node|
          node.type == :folder && node.name == storage_default_dir_name
        end
      end

      def folder_files
        @folder_files ||= folder.files
      end

      def get_file(filename)
        folder_files.detect { |f| f.name == filename }
      end

      def get_all_files_by_name(filename)
        folder_files.select { |f| f.name == filename }
      end
  end
end
