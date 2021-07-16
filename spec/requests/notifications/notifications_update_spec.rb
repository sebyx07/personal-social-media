# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PATCH /notifications/:id" do
  include_context "logged in"
  let(:notification) { create(:notification_friendship_request) }

  let(:params) do
    {
      notification: { seen: true }
    }
  end

  before do
    notification
  end

  subject do
    patch "/notifications/#{notification.id}", params: params
  end

  it "deletes a notification" do
    expect do
      subject
      notification.reload
    end.to change { notification.seen }.to(true)

    expect(response).to have_http_status(:ok)
    expect(json[:notification]).to be_present
  end
end
