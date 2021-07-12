# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PATCH /comments/:id" do
  include_context "logged in"
  let(:comment) { create(:comment, :standard, peer: Current.peer) }
  let(:cache_comment) do
    create(:cache_comment,
      remote_comment_id: comment.id,
      peer: comment.peer,
      subject_type: "RemotePost",
      subject_id: comment.subject.id,
      content: comment.content,
      comment_type: comment.comment_type
    )
  end
  let(:sample_comment) { build(:comment, :standard) }

  let(:params) do
    {
      comment: {
        content: sample_comment.content,
        comment_type: :standard
      }
    }
  end

  subject do
    patch "/comments/#{cache_comment.id}", params: params
  end

  it "update a comment locally" do
    cache_comment

    expect do
      subject
      expect(response).to have_http_status(:ok)
      comment.reload
    end.to change { comment.content }.to eq(sample_comment.content)

    expect(json[:comment]).to be_present
    expect(json.dig(:comment, :content, :message)).to be_present
  end
end
