# frozen_string_literal: true

module PeersService
  class Gravatar
    class Error < Exception; end
    attr_reader :email, :email_hexdigest, :size, :default
    def initialize(email: nil, email_hexdigest: nil)
      @email = email
      @email_hexdigest = email_hexdigest
    end

    def url(size: nil, default: nil)
      @size = size
      @default = default
      return handle_email if email.present?
      return handle_email_hexdigest if email_hexdigest.present?
      raise Error, "no email or email_hexdigest present"
    end

    private
      def handle_email
        @email_hexdigest = Digest::MD5.hexdigest(email)
        handle_email_hexdigest
      end

      def handle_email_hexdigest
        url = "//www.gravatar.com/avatar/" + email_hexdigest
        {}.tap do |options|
          options[:s] = size
          options[:d] = default
          options.compact!

          query = Rack::Utils.build_query(options)
          url += "?#{query}" if query.present?
        end

        url
      end
  end
end
