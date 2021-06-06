# frozen_string_literal: true

module PaginationService
  class Paginate
    attr_reader :scope, :query, :pagination_params, :limit
    def initialize(scope:, params:, limit:)
      @scope = scope
      @pagination_params = permitted_params(params)
      @limit = limit
    end

    def records
      @query = scope
      apply_pagination_cursor
      apply_pagination

      query
    end

    def apply_pagination_cursor
      return query if pagination_params.blank?
      @query = query.where("id < ?", pagination_params[:pagination][:from]).order(id: :desc)
    end

    def apply_pagination
      @query = query.limit(limit)
    end

    def permitted_params(params)
      return params.with_indifferent_access if params.is_a?(Hash)

      return params.permit(pagination: :from) if params.is_a?(ActionController::Parameters)

      params
    end
  end
end

ActionController::StrongParameters
