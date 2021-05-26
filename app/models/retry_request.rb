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
class RetryRequest < ApplicationRecord
  serialize :payload, JSON
  validates :payload, exclusion: { in: [nil] }
  serialize :peer_ids, Array
  validates :peer_ids, presence: true

  str_enum :request_method, %i(post put delete)
  str_enum :request_type, %i(single multiple)
  str_enum :status, %i(pending running completed failed)
  after_commit :perform, on: :create

  def perform
    RetryRequestsService::SchedulePerform.new(self).call!
  end

  def execute
    RetryRequestsService::ExecuteRetryRequest.new(self).call!
  end

  def peers
    @peers ||= Peer.where(id: peer_ids)
  end

  def batched_peer_ids(batch_size: HttpService::ApiClientBatch::AR_BATCH_SIZE)
    peer_ids.in_groups_of(batch_size, false).each do |peer_ids|
      yield Peer.where(id: peer_ids)
    end
  end

  def max_retries?
    retries == max_retries
  end
end
