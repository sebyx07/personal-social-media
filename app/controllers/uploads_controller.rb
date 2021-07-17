# frozen_string_literal: true

class UploadsController < ApplicationController
  def create
    @upload = Upload.create!(create_params)
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: 422
  end

  private
    def create_params
      params.require(:upload).permit(:subject_type, :subject_id)
    end
end
