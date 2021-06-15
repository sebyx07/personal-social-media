# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualCommentsService::CreateLocalComment do
  subject do
    VirtualCommentsService::CreateComment.new()
  end
end
