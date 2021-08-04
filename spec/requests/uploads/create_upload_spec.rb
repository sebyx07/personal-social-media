# frozen_string_literal: true

require "rails_helper"
require_relative "../../shared_contexts/setup_test_storage"

RSpec.describe "POST /uploads" do
  include_context "logged in"
  include_context "setup test storage"

  let(:params) do
    {
      upload: {
        subject_type: "Post",
        subject_id: post_id
      }
    }
  end

  subject do
    post "/uploads", params: params
  end

  context "valid" do
    let(:sample_post) { create(:post) }
    let(:post_id) { sample_post.id }

    it "creates a new upload" do
      expect do
        subject
      end.to change { Upload.count }.by(1)

      expect(response).to have_http_status(:ok)
      expect(json[:upload]).to be_present
    end
  end

  context "invalid" do
    let(:sample_post) { create(:post) }
    let(:post_id) { "1234" }

    it "returns error" do
      expect do
        subject
      end.not_to change { Upload.count }

      expect(response).to have_http_status(422)
      expect(json[:error]).to be_present
    end
  end
end
