# frozen_string_literal: true

require "rails_helper"

RSpec.describe PeersWorker::SyncRegularly, type: :request do
  include_context "two people"

  before do
    setup_my_peer(statuses: :friend)
    setup_other_peer(statuses: :friend)
  end

  subject do
    described_class.perform_async
  end

  it "syncs the peer" do
    subject

    Peer.all.each do |p|
      expect(p.server_last_seen_at).to be_present
    end
  end
end
