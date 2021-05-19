# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /api/instance/whoami" do
  include_context "api request"

  subject do
    post "/api/instance/whoami", params: encrypt_params({}), headers: headers
  end

  it "returns whoami of server and saves peer" do
    expect do
      subject
    end.to change { Peer.count }.to(1)

    expect(response).to have_http_status(:ok)
    expect(json[:profile][:name]).to be_present
    expect(json[:profile][:nickname]).to be_present
    expect(json[:profile][:email_hexdigest]).to be_present
    expect(json[:profile][:public_key]).to be_present
    expect(json[:profile][:verify_key]).to be_present
  end
end
