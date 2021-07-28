# frozen_string_literal: true

module FileSystemAdapters
  class UploadFile < BaseAdapter
    attr_reader :name, :file
    def initialize(name, file)
      @name = name
      @file = file
    end
  end
end
