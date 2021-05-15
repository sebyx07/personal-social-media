# frozen_string_literal: true

module FormsHelper
  def render_form_errors_for(record, field)
    message = record.errors.full_messages_for(field.to_s).join(". ")
    return if message.blank?

    content_tag "div", class: "text-red-600 text-xs" do
      message
    end
  end
end
