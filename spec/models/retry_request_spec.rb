# frozen_string_literal: true

# == Schema Information
#
# Table name: retry_requests
#
#  id             :bigint           not null, primary key
#  max_retries    :integer          default(0), not null
#  payload        :text             default({}), not null
#  peer_ids       :text             default("[]"), not null
#  request_method :string           not null
#  request_type   :string           not null
#  retries        :integer          default(0), not null
#  status         :string           default("pending"), not null
#  url            :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "rails_helper"

RSpec.describe RetryRequest, type: :model do
end
