# frozen_string_literal: true

class InstantUploadFilesController < ApplicationController
  def create
    @upload_file = InstantUploadFilesService::CreateNewInstantUpload.new(create_params).call!

  rescue ActiveRecord::RecordNotFound => e
    render json: { error: e.message }, status: 422
  end

  private
    def create_params
      params.require(:upload_file).permit(:upload_id, :file_name, :sha256)
    end
end
