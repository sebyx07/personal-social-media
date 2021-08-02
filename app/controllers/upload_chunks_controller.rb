# frozen_string_literal: true

class UploadChunksController < ApplicationController
  def show
    chunk_exists = UploadChunksService::CheckIfChunkExists.new(
      permitted_params_show[:flowIdentifier],
      permitted_params_show[:flowFilename],
      permitted_params_show[:flowChunkNumber]
    ).exists?

    return head :ok if chunk_exists
    render json: { error: "chunk not found" }, status: 422
  end

  def create
    upload_id = request.headers["PSM-UPLOAD-ID"]
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
      @permitted_params_show ||= params.permit(:flowIdentifier, :flowFilename, :flowChunkNumber)
    end

    def permitted_params_create
      @permitted_params_create ||= params.permit(
        :flowIdentifier, :flowFilename, :flowChunkNumber,
        :file, :flowChunkSize, :flowTotalSize
      )
    end
end
