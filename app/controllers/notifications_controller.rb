# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :require_current_notification, only: %i(update destroy trigger_event)

  def index
    scope = default_scope.includes(:peer).order(seen: :asc)
    pagination = PaginationService::Paginate.new(scope: scope, params: params, limit: 15)

    @notifications = pagination.records
  end

  def mark_all_as_seen
    default_scope.update_all(seen: true)
    head :ok
  end

  def update
    update_params = params.require(:notification).permit(:seen)
    current_notification.update!(update_params)

    @notification = current_notification
  end

  def trigger_event
    trigger_params = params.require(:notification).permit(:event_name, event_value: [])
    event_name = trigger_params[:event_name]
    event_value = trigger_params[:event_value]

    output = current_notification.handle_event_wrapper(event_name, event_value)

    render json: output

    rescue StandardError => e
      render json: { error: e.message }, status: 422
  end

  def destroy
    current_notification.destroy
    head :ok
  end

  private
    def default_scope
      Notification
    end

    def current_notification
      @current_notification ||= default_scope.find_by(id: params[:id])
    end

    def require_current_notification
      render json: { error: "Notification not found" }, status: 404 if current_notification.blank?
    end
end
