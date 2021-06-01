# frozen_string_literal: true

module PaginationService
  class Paginate
    attr_reader :scope, :query, :pagination_params, :limit
    def initialize(scope:, params:, limit:)
      @scope = scope
      @pagination_params = params.permit(pagination: :from)
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
      @query = query.where("id < ?", params[:pagination][:from]).order(id: :desc)
    end

    def apply_pagination
      @query = query.limit(limit)
    end
  end
end
