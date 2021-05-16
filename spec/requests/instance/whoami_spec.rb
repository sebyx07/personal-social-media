# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /api/instance/whoami" do
  include_context "api request"

  subject do
    post "/api/instance/whoami", params: encrypt_params({}), headers: headers
  end

  it "returns whoami of server" do
    subject
    expect(response).to have_http_status(:ok)
    expect(json[:profile][:name]).to be_present
  end
end
