# frozen_string_literal: true

require "rails_helper"

RSpec.describe "GET /notifications" do
  include_context "logged in"
  let(:notifications) { create_list(:notification_friendship_request, 10) }

  before do
    notifications
  end

  subject do
    get "/notifications"
  end

  it "returns list of notifications" do
    subject

    expect(response).to have_http_status(:ok)
    expect(json[:notifications]).to be_present
  end
end
