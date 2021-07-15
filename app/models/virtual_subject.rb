# frozen_string_literal: true

class VirtualSubject
  include BetterInspect
  attr_reader :params
  def initialize(params)
    @params = params
  end

  def subject_id
    params[:subject_id]
  end

  def subject_type
    params[:subject_type]
  end

  def resolve!
    subject_type.constantize.find_by(id: subject_id)
  end

  def valid?
    return false if subject_id.blank? || subject_type.blank?
    true
  end

  private
    def inspected_values
      {
        subject_id: subject_id,
        subject_type: subject_type,
      }
    end
end
