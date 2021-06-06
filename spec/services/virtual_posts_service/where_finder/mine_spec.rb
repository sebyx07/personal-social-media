# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualPostsService::WhereFinder, type: :request do
  include_context "two people"
  let(:posts) { create_list(:post, 2) }
  let(:pagination_params) { ActionController::Parameters.new({}) }

  context "mine posts" do
    before do
      my_peer

      posts
    end

    subject do
      described_class.new(pagination_params, peer_id: my_peer.id).results
    end

    it "returns two posts" do
      expect(subject.size).to eq(2)

      subject.each do |v_post|
        expect(v_post).to be_a(VirtualPost)
        expect(v_post.post).to be_present

        expect(VirtualPostPresenter.new(v_post).render).to be_present
      end
    end
  end
end
