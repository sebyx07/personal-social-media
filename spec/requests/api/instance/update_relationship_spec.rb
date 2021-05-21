# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /api/instance/update_relationship" do
  include_context "api request"
  let(:profile) { Current.profile }

  let(:params) do
    {
      relationship: :friendship_requested_by_external
    }
  end

  subject do
    stub_peer
    post "/api/instance/update_relationship", params: encrypt_params(params), headers: headers
  end

  it "returns the peer profile" do
    subject

    expect(response).to have_http_status(:ok)
    expect(json[:relationship]).to eq("friendship_requested_by_external")
  end
end
