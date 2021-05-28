# frozen_string_literal: true

module FlashHelper
  def flash_error(message)
    flash[:error] = message.capitalize
  end

  def flash_success(message)
    flash[:success] = message.capitalize
  end
end
