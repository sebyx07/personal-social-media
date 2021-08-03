# frozen_string_literal: true

class ManagementPsmFileDecorator < ApplicationDecorator
  decorates :psm_file
  delegate_all

  def presented
    PsmFilePresenter.new(object).render
  end
end
