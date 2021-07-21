# frozen_string_literal: true

class ManagementCdnStorageProviderDecorator < ApplicationDecorator
  include ActionView::Helpers::NumberHelper
  decorates :cdn_storage_provider
  delegate_all

  def name
    I18n.t("storage_adapters.#{adapter}.name")
  end

  def used_space_bytes_h
    number_to_human_size used_space_bytes
  end

  def free_space_bytes_h
    number_to_human_size free_space_bytes
  end
end
