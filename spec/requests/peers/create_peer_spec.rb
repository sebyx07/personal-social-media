# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /peers" do
  include_context "logged in"
  include_context "two people"

  let(:url) { "/peers" }
  let(:last_peer) { Peer.last }
  let(:parsed_message) { JSON.parse!(qr_code_body["message"]) }
  let(:qr_code_body) do
    TwoPeopleHelper.take_over_wrap! do
      ProfilesService::ShareableQrCode.new.call
    end.as_json
  end

  subject do
    post url, params: qr_code_body.to_json, headers: headers
  end

  it "creates a new peer" do
    subject

    expect(response).to have_http_status(:ok)

    expect(Peer.count).to eq(2)
    expect(last_peer.name).to eq(parsed_message["name"])

    expect(raw_json[:peer]).to be_present
  end
end
