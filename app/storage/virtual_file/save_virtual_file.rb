# frozen_string_literal: true

class VirtualFile
  class SaveVirtualFile
    attr_reader :virtual_file, :subject
    def initialize(virtual_file, subject)
      @virtual_file = virtual_file
      @subject = subject
    end

    def call
      permanent_psm_files.each do |permanent_file|
        permanent_file.virtual_file = virtual_file
        permanent_file.archive_password = archive_password
      end
      protected_archive.generate_archive
      virtual_file.protected_archive = protected_archive
      permanent_psm_files.each do |permanent_file|
        permanent_file.adapter_instance.upload(permanent_file)
      end
      update_permanent_psm_files!
      self
    end

    # def call
    #   permanent_psm_files.virtual_file = virtual_file
    #

    #
    #   adapter.set_account(saving_account)
    #   adapter.upload(permanent_psm_file)
    #
    # update_permanent_psm_files!
    #   self
    # rescue Exception => e
    #   rollback_from_db
    #   raise e
    # end

    def psm_file
      return @psm_file if defined? @psm_file
      @psm_file = PsmFile.new(PsmFile::ExtractAttributesFromFile.new(virtual_file.original_physical_file).attributes).tap do |psm_file|
        psm_file.subject = subject
        psm_file.save!
      end
    end

    def psm_original_variant
      @psm_original_variant ||= PsmFileVariant::CreateOriginal.new(psm_file).save!
    end

    private
      def permanent_storage_accounts
        @permanent_storage_accounts ||= ExternalAccount::GetPermanentStorageAccounts.new
      end

      def adapters
        @adapters ||= permanent_storage_accounts.adapters
      end

      def permanent_psm_files
        @permanent_psm_file ||= adapters.map do |adapter|
          PsmPermanentFile.new(
            psm_file_variant: psm_original_variant,
            external_account: adapter.storage_account,
            adapter: adapter.class.name
          ).tap do |permanent_file|
            permanent_file.adapter_instance = adapter
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
        @protected_archive ||= ArchiveService::ProtectedArchive.new(file: virtual_file.original_physical_file, file_name: file_name, password: archive_password)
      end

      def rollback_from_db
        permanent_psm_file.delete
        psm_original_variant.delete
        psm_file.delete
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
  end
end
