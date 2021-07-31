# frozen_string_literal: true

class SafeTempfile < Tempfile
  class_attribute :generated_temp_files_paths, default: []
  class_attribute :opened_files, default: []

  def initialize(*arg, **options)
    super
    opened_files << self
  end

  class << self
    def clean_safe_temp_files!(sidekiq: false)
      opened_files.each(&:close!) if sidekiq
      FileUtils.rm_rf(generated_temp_files_paths) if generated_temp_files_paths.present?

      self.generated_temp_files_paths = []
      self.opened_files = []
    end

    def generate_new_temp_file_path(extension: nil)
      path = "/tmp/#{SecureRandom.hex(50)}"
      if extension
        path += ".#{extension}"
      end

      path.tap do |p|
        generated_temp_files_paths << p
      end
    end
  end
end
