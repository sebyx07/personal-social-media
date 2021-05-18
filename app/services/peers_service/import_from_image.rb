# frozen_string_literal: true

module PeersService
  class ImportFromImage
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call!
      p params
    end
  end
end
