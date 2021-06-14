# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualReaction, type: :request do
  include_context "two people"

  describe "VirtualReactionsService" do
    describe "VirtualReactionsService::WhereFinder::FindRemotely" do
      describe ".results" do
        context "externally" do
          let(:my_post) { create(:post) }
          let(:remote_post) { my_post.remote_post }
          let(:reaction_counter) { create(:reaction_counter, subject: my_post) }
          let(:reactions) { create_list(:reaction, 2, reaction_counter: reaction_counter) }

          subject do
            described_class.where(pagination_params: {}, subject_type: "RemotePost", subject_id: remote_post.id)
          end

          before do
            setup_my_peer(statuses: :friend)
            setup_other_peer(statuses: :friend)

            remote_post.update(peer: other_peer)
            reactions
          end

          it "returns 2 virtual reactions" do
            subject
            expect(subject.size).to eq(2)

            subject.each do |v_reaction|
              expect(v_reaction).to be_a(VirtualReaction)

              expect(VirtualReactionPresenter.new(v_reaction).render).to be_present
            end
          end
        end
      end
    end
  end
end
