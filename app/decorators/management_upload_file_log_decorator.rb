# frozen_string_literal: true

class ManagementUploadFileLogDecorator < ApplicationDecorator
  include ActionView::Helpers::TagHelper
  class UnknownStatusColor < StandardError; end
  decorates :upload_file_log
  delegate_all

  def colored_message
    color = if ok?
      "text-green-600"
    elsif error?
      "text-red-500"
    else
      raise UnknownStatusColor
    end

    icon = ok? ? "fas fa-check" : "fas fa-times"
    icon_tag = "<i class='#{icon}'></i>"

    "<span class='#{color}'>#{icon_tag} #{message}</span>".html_safe
  end
end
