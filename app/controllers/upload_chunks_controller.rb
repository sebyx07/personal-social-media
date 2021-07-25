# frozen_string_literal: true

class UploadChunksController < ApplicationController
  def show
    chunk_exists = UploadChunksService::CheckIfChunkExists.new(
      permitted_params_show[:resumableIdentifier],
      permitted_params_show[:resumableFilename],
      permitted_params_show[:resumableChunkNumber]
    ).exists?

    return head :ok if chunk_exists
    head 404
  end

  def create
    upload_id = request.headers["PSM_UPLOAD_ID"]
    head 404 unless upload_id
    UploadChunksService::UploadChunk.new(permitted_params_create, upload_id).handle_chunk.tap do |service|
      if service.whole_file_ready?
        service.process_whole_file
      end

      head :ok
    end
  end

  private
    def permitted_params_show
      @permitted_params_show ||= params.permit(:resumableIdentifier, :resumableFilename, :resumableChunkNumber)
    end

    def permitted_params_create
      @permitted_params_create ||= params.permit(
        :resumableIdentifier, :resumableFilename, :resumableChunkNumber,
        :file, :resumableChunkSize, :resumableTotalSize
      )
    end
end
