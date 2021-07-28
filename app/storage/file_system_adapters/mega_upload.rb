# frozen_string_literal: true

module FileSystemAdapters
  class MegaUpload < BaseAdapter
    # def bootstrap
    #   client.root.create_folder(storage_default_dir_name)
    # end
    #
    # def upload(psm_permanent_file)
    #   archive = psm_permanent_file.virtual_file&.protected_archive&.archive
    #   raise_upload_error("no physical_file") if archive.blank?
    #
    #   folder.upload(archive.path)
    # end
    #
    # private
    #   def client
    #     return @client if defined? @client
    #     @client = Rmega.login(storage_account.email, storage_account.password)
    #   rescue Rmega::ServerError => e
    #     raise_adapter_error("invalid login", e)
    #   end
    #
    #   def folder
    #     @folder ||= client.nodes.find do |node|
    #       node.type == :folder && node.name == storage_default_dir_name
    #     end
    #   end
  end
end
