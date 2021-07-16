# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DELETE /notifications/:id" do
  include_context "logged in"
  let(:notification) { create(:notification_friendship_request) }

  before do
    notification
  end

  subject do
    delete "/notifications/#{notification.id}"
  end

  it "deletes a notification" do
    expect do
      subject
    end.to change { Notification.count }.by(-1)

    expect(response).to have_http_status(:ok)
  end
end
