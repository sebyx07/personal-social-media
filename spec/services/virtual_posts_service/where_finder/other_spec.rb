# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualPostsService::WhereFinder, type: :request do
  include_context "two people"
  let(:posts) do
    take_over_wrap! do
      create_list(:post, 2, :with_reactions, :with_comments)
    end
  end

  let(:cache_comments) do
    posts.each do |post|
      post.comments.each do |comment|
        create(:cache_comment, :standard, peer_id: other_peer.id, remote_comment_id: comment.id,
               remote_parent_comment_id: comment.parent_comment_id, subject_type: "RemotePost",
               subject_id: RemotePost.find_by(remote_post_id: post.id).id,
               )
      end
    end
  end

  let(:pagination_params) { ActionController::Parameters.new({}) }

  context "other peers posts" do
    before do
      setup_my_peer(statuses: :friend)
      setup_other_peer(statuses: :friend)

      RemotePost.where(remote_post_id: posts.map(&:id)).update_all(peer_id: reverse_my_peer.id)
      cache_comments

      Peer.where.not(id: Current.peer.id).find_each do |peer|
        peer.update!(status: %i(friend))
      end
    end

    subject do
      described_class.new(pagination_params, peer_id: other_peer.id).results
    end

    it "returns 1 post" do
      expect(subject.size).to eq(2)

      subject.each do |v_post|
        expect(v_post).to be_a(VirtualPost)
        expect(v_post.request).to be_present

        VirtualPostPresenter.new(v_post).render.tap do |json|
          expect(json).to be_present
          expect(json[:is_valid]).to be_truthy

          json[:latest_comments].each do |comment|
            peer = comment[:peer]
            expect(peer[:status]).to match_array(:friend)

            expect(comment[:cache_comment_id]).to be_present
          end
        end
      end
    end
  end
end
