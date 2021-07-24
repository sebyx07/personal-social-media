import MessageBoxFormWithAttachments from '../util/communication/message-box-form-with-attachments';
import commentForModel from '../../utils/comments/comment-for-model';

export default function StandardPostNewComment({post}) {
  async function saveComment(message) {
    const {data: {comment: newComment}} = await commentForModel({
      commentType: 'standard',
      content: {message},
      parentCommentId: null,
      subjectId: post.id.get(),
      subjectType: 'RemotePost',
    });

    post.latestComments.merge([newComment]);
  }

  return (
    <MessageBoxFormWithAttachments
      submit={saveComment}
      messageBoxClassName="bg-gray-100 hover:bg-white"
      clearOnSubmit={true}
      placeholder="Your comment"
      buttonText="Save"
    />
  );
}
