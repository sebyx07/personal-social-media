# frozen_string_literal: true

module PsmAttachmentConcern
  extend ActiveSupport::Concern

  class_methods do
    def has_many_psm_files_attached
      has_many :psm_attachments, dependent: :destroy, as: :subject
      has_many :psm_files, through: :psm_attachments
      has_many :psm_file_variants, through: :psm_attachments
      has_many :psm_permanent_files, through: :psm_attachments
      has_many :psm_cdn_files, through: :psm_attachments
    end
  end

  included do
    def attachments
      psm_cdn_files.group_by(&:psm_file_variant).map do |psm_file_variant, grouped_cdn_files|
      end
      psm_cdn_files.map do |psm_cdn_file|
      end
    end
  end
end
