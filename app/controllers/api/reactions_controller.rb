module Api
  class ReactionsController
    def index

    end

    def create
      @post = current_post
    end
  end
end