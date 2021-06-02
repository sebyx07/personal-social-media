# frozen_string_literal: true

module PostsWorker
  class PropagateNewPostWorker < ApplicationWorker
    attr_reader :post
    def perform(post_id)
      @post = Post.find_by(id: post_id)
      return if post.blank?

      HttpService::ApiClientBatch.run_with_retry_in_background(
        template_request: template_request,
        all: true
      )
    end

    def template_request
      return @template_request if defined? @template_request
      body = {
        post: {
          id: post.id,
          post_type: post.post_type
        }
      }

      @template_request = HttpService::TemplateApiRequest.new(url: "/remote_posts", body: body, method: :post)
    end
  end
end
