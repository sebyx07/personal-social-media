# frozen_string_literal: true

module PostsService
  class GenerateName
    attr_reader :post
    def initialize(post)
      @post = post
    end

    def call
      "Post #{formatted_id} #{formatted_date} #{content}".squish
    end

    private
      def formatted_date
        created_at.strftime("%B %-d %Y")
      end

      def created_at
        @created_at ||= post.created_at || Time.zone.now
      end

      def formatted_id
        "#{post.id})"
      end

      def content
        return if post.message.blank?

        post.message.first(30)
      end
  end
end
