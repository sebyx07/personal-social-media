# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /api/instance/sync" do
  include_context "api request"
  let(:profile) { Current.profile }

  let(:params) do
    {
      profile: {
        name: profile.name,
        nickname: profile.nickname,
        domain_name: profile.domain_name,
        email_hexdigest: profile.email_hexdigest,
      }
    }
  end

  subject do
    post "/api/instance/sync", params: encrypt_params(params), headers: headers
  end

  it "returns the peer profile" do
    subject

    expect(response).to have_http_status(:ok)
    expect(json[:profile]).to be_present
  end
end
