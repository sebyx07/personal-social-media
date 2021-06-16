# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /peers/search" do
  include_context "logged in"

  describe "search by public key" do
    let(:peer) { create(:peer) }
    let(:url) { "/peers/search" }
    let(:params) do
      {
        q: {
          public_key: EncryptionService::EncryptedContentTransform.to_json(peer.public_key.to_s)
        }
      }
    end

    subject do
      post url, params: params
    end

    it "creates a new peer" do
      subject
      expect(response).to have_http_status(:ok)

      expect(json[:peers].size).to eq(1)
    end
  end
end
