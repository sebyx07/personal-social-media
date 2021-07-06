# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualPostsService::WhereFinder, type: :request do
  include_context "two people"
  let(:posts) do
    take_over_wrap! do
      create_list(:post, 1)
    end
  end

  let(:pagination_params) { ActionController::Parameters.new({}) }

  context "other peers posts" do
    before do
      setup_my_peer(statuses: :friend)
      setup_other_peer(statuses: :friend)

      RemotePost.where(remote_post_id: posts.map(&:id)).update_all(peer_id: reverse_my_peer.id)
    end

    subject do
      described_class.new(pagination_params, peer_id: other_peer.id).results
    end

    it "returns 2 post" do
      expect(subject.size).to eq(1)

      subject.each do |v_post|
        expect(v_post).to be_a(VirtualPost)
        expect(v_post.request).to be_present

        VirtualPostPresenter.new(v_post).render.tap do |json|
          expect(json).to be_present
          expect(json[:is_valid]).to be_truthy
        end
      end
    end
  end
end
