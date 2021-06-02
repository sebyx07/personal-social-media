# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualPostsService::WhereFinder, type: :request do
  include_context "two people"
  let(:posts) { create_list(:post, 2) }
  let(:other_posts) { create_list(:post, 2) }
  let(:pagination_params) { ActionController::Parameters.new({}) }

  context "mixed posts" do
    before do
      posts
      setup_my_peer(statuses: :friend)
      setup_other_peer(statuses: :friend)

      RemotePost.where(remote_post_id: other_posts.map(&:id)).update_all(peer_id: other_peer.id)
    end

    subject do
      described_class.new(pagination_params).results
    end

    it "returns 4 post" do
      expect(subject.size).to eq(4)
      subject.each do |v_post|
        expect(v_post).to be_a(VirtualPost)
      end
    end
  end
end
