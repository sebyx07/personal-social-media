# frozen_string_literal: true

class SafeFileRackMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)

    body_proxy = Rack::BodyProxy.new(body) do
      SafeFile.close_opened_files!
      SafeTempfile.clean_safe_temp_files!
    end

    [status, headers, body_proxy]
  end
end
