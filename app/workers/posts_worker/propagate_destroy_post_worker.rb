# frozen_string_literal: true

module PostsWorker
  class PropagateDestroyPostWorker < ApplicationWorker
    attr_reader :post_id
    def perform(post_id)
      @post_id = post_id

      HttpService::ApiClientBatch.run_with_retry_in_background(
        template_request: template_request,
        all: true
      )
    end

    def template_request
      return @template_request if defined? @template_request

      @template_request = HttpService::TemplateApiRequest.new(url: "/remote_posts/#{post_id}", method: :delete)
    end
  end
end
