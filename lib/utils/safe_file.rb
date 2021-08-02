# frozen_string_literal: true

class SafeFile < File
  class_attribute :opened_files, default: []

  class << self
    def close_opened_files!
      return if opened_files.blank?
      opened_files.each(&:close)
      self.opened_files = []
    end

    def open(*arguments, &block)
      File.open(*arguments).tap do |f|
        block.call(f) if block_given?
        opened_files << f
      end
    end
  end
end
