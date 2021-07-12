# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DELETE /comments/:id" do
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

  subject do
    delete "/comments/#{cache_comment.id}"
  end

  it "deletes a comment locally" do
    cache_comment

    expect do
      subject
      expect(response).to have_http_status(:ok)
    end.to change { Comment.count }.by(-1)
       .and change { CacheComment.count }.by(-1)

    expect(json[:ok]).to be_present
  end
end
