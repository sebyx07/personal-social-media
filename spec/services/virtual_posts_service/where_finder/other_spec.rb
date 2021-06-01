# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualPostsService::WhereFinder, type: :request do
  include_context "two people"
  let(:posts) { create_list(:post, 1) }
  let(:pagination_params) { ActionController::Parameters.new({}) }

  let(:setup_external_me) do
    expect_any_instance_of(Api::BaseController).to receive(:hook_into_current_peer).and_return ->(peer) do
      peer.update!(status: %i(friend))
    end
  end

  context "other peers posts" do
    before do
      current_peer

      RemotePost.where(remote_post_id: posts.map(&:id)).update_all(peer_id: other_peer.id)
      setup_external_me
      other_peer.update!(status: %i(friend))
    end

    subject do
      described_class.new(pagination_params, other_peer.id).results
    end

    xit "returns 1 post" do
      expect(subject.size).to eq(1)

      subject.each do |v_post|
        expect(v_post).to be_a(VirtualPost)
      end
    end
  end
end
