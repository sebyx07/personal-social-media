# frozen_string_literal: true

module ArchiveService
  class ProtectedArchive
    class Error < StandardError; end
    attr_reader :file, :archive, :password, :file_name
    def initialize(file: nil, archive: nil, password:, file_name:)
      @file = file
      @archive = archive
      @password = password
      @file_name = file_name
    end

    def size
      check_file
      File.size(file.path)
    end

    def archive_size
      check_archive
      File.size(archive.path)
    end

    def generate_archive
      check_file

      command = "7za a #{new_archive_path} #{file.path} -tzip -mem=AES256 -mx9 -p#{password} > /dev/null"
      system(command)
      raise Error, "archive not created" unless File.exist?(new_archive_path)

      @archive ||= File.open(new_archive_path)
    end

    def extract_archive
      check_archive

      command = "7z e #{archive.path} -o'#{new_file_dir_name}' -p#{password} > /dev/null"
      system(command)
      raise Error, "file not created" unless File.exist?(new_file_path)

      @file ||= File.open(new_archive_path)
    end

    def clean_archive!
      return if archive.blank?
      FileUtils.rm_rf([archive.path])
    end

    def clean_file!
      return if file.blank?
      FileUtils.rm_rf([file.path])
    end

    def new_archive_name
      @new_archive_name ||= "#{SecureRandom.hex}-#{file_name}.zip"
    end

    private
      def new_archive_path
        @new_archive_path ||= "/tmp/#{new_archive_name}"
      end

      def new_file_dir_name
        @new_file_dir_name ||= "/tmp/#{SecureRandom.hex}-#{file_name.parameterize}"
      end

      def new_file_path
        @new_file_path ||= "#{new_file_dir_name}/#{file_name}"
      end

      def check_file
        raise Error, "no file" if file.blank?
      end

      def check_archive
        raise Error, "no file" if file.blank?
      end
  end
end
