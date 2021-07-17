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

  private
    def permitted_params_show
      @permitted_params ||= params.permit(:resumableIdentifier, :resumableFilename, :resumableChunkNumber)
    end
end
