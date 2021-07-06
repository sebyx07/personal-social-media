# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualPostsService::WhereFinder, type: :request do
  include_context "two people"
  let(:posts) { create_list(:post, 2, :with_reactions, :with_comments) }
  let(:pagination_params) { ActionController::Parameters.new({}) }

  context "mine posts" do
    before do
      my_peer

      posts

      Peer.where.not(id: Current.peer.id).find_each do |peer|
        peer.update!(status: %i(friend))
      end
    end

    subject do
      described_class.new(pagination_params, peer_id: my_peer.id).results
    end

    it "returns two posts" do
      expect(subject.size).to eq(2)

      subject.each do |v_post|
        expect(v_post).to be_a(VirtualPost)
        expect(v_post.post).to be_present

        VirtualPostPresenter.new(v_post).render.tap do |json|
          expect(json).to be_present
          expect(json[:reaction_counters]).to be_present
          expect(json[:latest_comments]).to be_present
          json[:latest_comments].each do |comment|
            peer = comment[:peer]
            expect(peer[:status]).to match_array(:friend)
          end
        end
      end
    end
  end
end
