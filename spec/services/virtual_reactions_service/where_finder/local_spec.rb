# frozen_string_literal: true

require "rails_helper"

RSpec.describe VirtualReaction do
  describe "VirtualReactionsService" do
    describe "VirtualReactionsService::WhereFinder::FindLocal" do
      describe ".results" do
        context "locally" do
          let(:post) { create(:post) }
          let(:remote_post) { post.remote_post }
          let(:reaction_counter) { create(:reaction_counter, subject: post) }
          let(:reactions) { create_list(:reaction, 2, reaction_counter: reaction_counter) }

          subject do
            described_class.where(pagination_params: {}, subject_type: "Post", subject_id: remote_post.id)
          end

          before do
            reactions
          end

          it "returns 2 virtual reactions" do
            expect(subject.size).to eq(2)

            subject.each do |v_reaction|
              expect(v_reaction).to be_a(VirtualReaction)
            end
          end
        end
      end
    end
  end
end
