import MessageBoxForm from '../util/communication/message-box-form';
import commentForModel from '../../utils/comments/comment-for-model';

export default function StandardPostComment({post}) {
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
    <MessageBoxForm
      submit={saveComment}
      messageBoxClassName="bg-gray-100 hover:bg-white"
      clearOnSubmit={true}
      placeholder="Your comment"
      buttonText="Save"
    />
  );
}
