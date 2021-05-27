# frozen_string_literal: true

class VirtualFile
  class Error < StandardError; end
  attr_reader :original_physical_file
  attr_accessor :protected_archive

  def initialize(original_physical_file: nil, psm_file: nil)
    @original_physical_file = original_physical_file
    @psm_file = psm_file
  end

  def save!(subject)
    raise Error, "no original_physical_file" if original_physical_file.blank?

    @save_virtual_file = SaveVirtualFile.new(self, subject).call
  end

  def download
  end
end
