export default function EditComment({comment}) {
  const isMe = comment.peer.isMe.get();

  if (!isMe) return null;
  return (
    <div className="pl-4">
      <a href="#" className="text-sm">Edit</a>
    </div>
  );
}
