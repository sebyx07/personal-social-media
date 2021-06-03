# frozen_string_literal: true

RSpec.shared_examples "reactions for resource create" do
  include_context "logged in"
  include_context "two people"
  let(:sample_react) { build(:cache_reaction) }
  let(:params) do
    { reaction: { character: sample_react.character } }
  end

  subject do
    post url, params: params
  end

  before do
    setup_my_peer(statuses: :friend)
    setup_other_peer(statuses: :friend)
  end

  it "increments counters" do
    expect do
      subject
      expect(response).to have_http_status(:ok)
    end.to change { Reaction.count }.by(1)
      .and change { CacheReaction.count }.by(1)
      .and change { ReactionCounter.count }.by(1)
  end
end

RSpec.shared_examples "reactions for resource destroy" do
  include_context "logged in"
  include_context "two people"
  let(:sample_react) { build(:cache_reaction) }
  let(:params) do
    { reaction: { character: sample_react.character } }
  end

  subject do
    delete url, params: params
  end

  before do
    setup_my_peer(statuses: :friend)
    setup_other_peer(statuses: :friend)
    cache_reaction
  end

  it "decrements counters" do
    expect do
      subject
      expect(response).to have_http_status(:ok)
    end.to change { Reaction.count }.by(-1)
        .and change { CacheReaction.count }.by(-1)
  end
end
