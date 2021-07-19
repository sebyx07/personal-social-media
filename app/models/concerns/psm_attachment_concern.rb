# frozen_string_literal: true

module PsmAttachmentConcern
  extend ActiveSupport::Concern

  class_methods do
    def has_many_psm_files_attached
      has_many :psm_files, dependent: :destroy, as: :subject
      has_many :psm_file_variants, through: :psm_files
      has_many :psm_permanent_files, through: :psm_files
      has_many :psm_cdn_files, through: :psm_files
    end
  end
end
