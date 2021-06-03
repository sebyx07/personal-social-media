# frozen_string_literal: true

class ReactionsController < ApplicationController
  before_action :require_subject_type
  attr_reader :subject_id

  def index
  end

  def create
    @cache_reaction = VirtualReaction.react_for_resource(subject_type, subject_id, permitted_params[:character])
  end

  def destroy
    VirtualReaction.remove_react_for_resource(subject_type, subject_id, permitted_params[:character])
    head :ok
  end

  def require_subject_type
    render json: { error: "Unknown subject" }, status: 422 if subject_type.blank?
  end

  def subject_type
    return @subject_type if defined? @subject_type
    if params[:post_id].present?
      @subject_id = params[:post_id]
      @subject_type = "RemotePost"
    end

    @subject_type
  end

  def permitted_params
    @permitted_params ||= params.require(:reaction).permit(:character)
  end
end
