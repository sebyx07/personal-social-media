# frozen_string_literal: true

class VirtualFile
  class SaveVirtualFile
    attr_reader :virtual_file, :subject
    def initialize(virtual_file, subject)
      @virtual_file = virtual_file
      @subject = subject
    end

    def call
      permanent_psm_file.virtual_file = virtual_file

      protected_archive.generate_archive
      virtual_file.protected_archive = protected_archive

      adapter.set_account(saving_account)
      adapter.upload(permanent_psm_file)

      update_permanent_psm_file!
      self
    rescue Exception => e
      rollback_from_db
      raise e
    end

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
      def saving_account
        @saving_account ||= ExternalAccount::StorageAccount.current
      end

      def adapter
        @adapter ||= saving_account.dynamic_adapter.new
      end

      def permanent_psm_file
        @permanent_psm_file ||= PsmPermanentFile.new(psm_file_variant: psm_original_variant, external_account: saving_account)
      end

      def file_name
        @file_name ||= File.basename(virtual_file.original_physical_file.path)
      end

      def password
        permanent_psm_file.generate_archive_password
      end

      def protected_archive
        @protected_archive ||= ArchiveService::ProtectedArchive.new(file: virtual_file.original_physical_file, file_name: file_name, password: password)
      end

      def rollback_from_db
        permanent_psm_file.delete
        psm_original_variant.delete
        psm_file.delete
      end

      def update_permanent_psm_file!
        permanent_psm_file.external_file_name = protected_archive.new_archive_name
        permanent_psm_file.size_bytes = protected_archive.archive_size
        permanent_psm_file.status = :ready
        permanent_psm_file.save!
      end
  end
end
