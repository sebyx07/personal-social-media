# frozen_string_literal: true

require "rails_helper"

RSpec.describe "DELETE /comments/:id" do
  include_context "logged in"
  include_context "two people"

  let(:comment) { create(:comment, :standard, peer: my_peer) }
  let(:cache_comment) do
    create(:cache_comment,
      remote_comment_id: comment.id,
      peer: other_peer,
      subject_type: "RemotePost",
      subject_id: comment.subject.id,
      content: comment.content,
      comment_type: comment.comment_type
    )
  end

  before do
    setup_my_peer(statuses: :friend)
    setup_other_peer(statuses: :friend)
  end

  subject do
    delete "/comments/#{cache_comment.id}"
  end

  xit "deletes a comment externally" do
    cache_comment

    expect do
      subject
      expect(response).to have_http_status(:ok)
    end.to change { Comment.count }.by(-1)
       .and change { CacheComment.count }.by(-1)

    expect(json[:ok]).to be_present
  end
end
