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
    def content_with_attachments
      return content if psm_attachments.blank?
      content.merge(
        attachments: psm_attachments.map do |attachment|
          PsmAttachmentPresenter.new(attachment).render_inside_content
        end
      )
    end
  end
end
