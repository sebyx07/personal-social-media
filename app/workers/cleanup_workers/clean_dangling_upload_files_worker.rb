# frozen_string_literal: true

module CleanupWorkers
  class CleanDanglingUploadFilesWorker < ApplicationWorker
    def perform
      UploadFile.dangling.find_in_batches do |dangling_upload_files|
        dangling_upload_files.each do |upload_file|
          upload_file.destroy
          upload_file.clean_parent_upload
        end
      end

      Upload.dangling.destroy_all
    end
  end
end
