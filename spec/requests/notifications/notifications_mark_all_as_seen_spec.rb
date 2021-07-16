# frozen_string_literal: true

require "rails_helper"

RSpec.describe "POST /notifications/mark_all_as_seen" do
  include_context "logged in"
  let(:notifications) { create_list(:notification_friendship_request, 10) }

  before do
    notifications
  end

  subject do
    post "/notifications/mark_all_as_seen"
  end

  it "returns list of notifications" do
    expect do
      subject
    end.to change { Notification.where(seen: true).count }.to(10)
      .and change { Notification.where(seen: false).count }.to(0)

    expect(response).to have_http_status(:ok)
  end
end
