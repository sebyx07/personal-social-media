# frozen_string_literal: true

class VirtualFile
  class SavePermanentFiles
    include Memo
    attr_reader :virtual_file, :psm_file, :psm_original_variant
    def initialize(virtual_file, psm_file, psm_original_variant)
      @virtual_file = virtual_file
      @psm_file = psm_file
      @psm_original_variant = psm_original_variant
    end

    def call
      permanent_psm_files.each do |permanent_file|
        permanent_file.virtual_file = virtual_file
        permanent_file.archive_password = archive_password
      end
      protected_archive.generate_archive
      virtual_file.protected_archive = protected_archive
      permanent_psm_files.each do |permanent_file|
        archive = permanent_file.virtual_file&.protected_archive&.archive
        notify_progress.notify_upload_permanent_file(permanent_file, :start)
        permanent_file.permanent_storage_provider.upload(archive)
        notify_progress.notify_upload_permanent_file(permanent_file, :end)
      end
      update_permanent_psm_files!
    end

    private
      def permanent_storage_providers
        @permanent_storage_providers ||= PermanentStorageProvider.where(enabled: true)
      end

      def permanent_psm_files
        memo :@permanent_psm_file do
          permanent_storage_providers.map do |permanent_storage_provider|
            PsmPermanentFile.new(
              psm_file_variant: psm_original_variant,
              permanent_storage_provider: permanent_storage_provider,
            )
          end
        end
      end

      def file_name
        @file_name ||= File.basename(virtual_file.original_physical_file.path)
      end

      def archive_password
        @archive_password ||= SecureRandom.urlsafe_base64(64)
      end

      def protected_archive
        memo :@protected_archive do
          ArchiveService::ProtectedArchive.new(file: virtual_file.original_physical_file, file_name: file_name, password: archive_password)
        end
      end

      def update_permanent_psm_files!
        size_bytes = protected_archive.archive_size
        external_file_name = protected_archive.new_archive_name

        permanent_psm_files.each do |permanent_psm_file|
          permanent_psm_file.external_file_name = external_file_name
          permanent_psm_file.size_bytes = size_bytes
          permanent_psm_file.status = :ready
          permanent_psm_file.save!
        end
      end

      def notify_progress
        @notify_progress ||= UploadsService::NotifyProgress.new
      end
  end
end
