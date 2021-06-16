# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /api/reactions" do
  include_context "api request"
  let(:profile) { Current.profile }
  let(:sample_reaction) { build(:cache_reaction) }
  let(:my_post) { create(:post) }
  let(:params) do
    {
      reaction: {
        subject_type: "Post",
        subject_id: my_post.id,
        character: sample_reaction.character
      }
    }
  end

  subject do
    stub_peer
    peer.update!(status: %i(friend))

    post "/api/reactions", params: encrypt_params(params), headers: headers
  end

  it "creates reaction" do
    expect do
      subject
      expect(response).to have_http_status(:ok)
    end.to change { Reaction.count }.by(1)

    expect(json[:reaction]).to be_present
  end
end
