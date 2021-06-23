import MessageBoxForm from '../util/communication/message-box-form';

export default function StandardPostComment({post}) {
  function saveComment() {
  }

  return (
    <MessageBoxForm
      submit={saveComment}
      messageBoxClassName="bg-gray-100 rounded border border-solid focus:border-gray-400 border-gray-200"
      clearOnSubmit={true}
      placeholder="Your comment"
    />
  );
}
