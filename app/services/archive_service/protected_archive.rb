# frozen_string_literal: true

module ArchiveService
  class ProtectedArchive
    class Error < StandardError; end
    attr_reader :file, :archive, :password, :file_name
    def initialize(file: nil, archive: nil, password:, file_name: nil)
      @file = file
      @archive = archive
      @password = password
      @file_name = file_name
    end

    def size
      check_file
      SafeFile.size(file.path)
    end

    def archive_size
      return @archive_size if defined? @archive_size
      check_archive
      @archive_size = SafeFile.size(archive.path)
    end

    def generate_archive
      check_file

      command = "7za a #{new_archive_path} #{file.path} -tzip -mem=AES256 -mx9 -p#{password} > /dev/null"
      system(command)
      raise Error, "archive not created" unless SafeFile.exist?(new_archive_path)

      @archive = SafeFile.open(new_archive_path)
      archive_size
      @archive
    end

    def extract_archive
      check_archive

      command = "7z e #{archive.path} -o'#{new_file_dir_name}' -p#{password} > /dev/null"
      system(command)
      raise Error, "file not created" unless SafeFile.exist?(new_file_path)

      @file ||= SafeFile.open(new_file_path)
    end

    def clean_archive!
      return if archive.blank?
      FileUtils.rm_rf([archive.path])
    end

    def clean_output_file!
      return if new_file_path.blank?
      FileUtils.rm_rf([new_file_path])
    end

    def new_archive_name
      new_archive_path.sub("/tmp", "")
    end

    private
      def new_archive_path
        @new_archive_path ||= SafeTempfile.generate_new_temp_file_path(extension: :zip)
      end

      def new_file_dir_name
        @new_file_dir_name ||= SafeTempfile.generate_new_temp_file_path
      end

      def new_file_path
        return @new_file_path if @new_file_path.present?
        @new_file_path = Dir.glob("#{new_file_dir_name}/*").first
      end

      def check_file
        raise Error, "no file" if file.blank?
      end

      def check_archive
        raise Error, "no archive" if archive.blank?
      end
  end
end
