import {getHookstateProperties} from '../../lib/hookstate/get-properties';
import {timeAgoInWords} from '../../lib/dates/time-ago';
import CommentStandardContent from './content-standard';
import EditComment from './edit-comment';
import RemotePeerAvatar from '../peers/avatars/remote-avatar';

export default function Comment({data: comment}) {
  const {commentType} = getHookstateProperties(comment, 'commentType', 'peer');
  let ContentTag;
  switch (commentType) {
    case 'standard':
      ContentTag = CommentStandardContent;
  }

  return (
    <div className="py-1">
      <div className="bg-gray-300 rounded p-2">
        <RemotePeerAvatar peer={comment.peer} imageClassName="h-8 w-8" nameClassName="text-sm">
          <>
            <div className="text-sm">
              {timeAgoInWords(comment.createdAt.get())}
            </div>

            <div className="flex flex-wrap content-end pt-1">
              <div className="flex-1">
                <ContentTag comment={comment}/>
              </div>
              <EditComment comment={comment}/>
            </div>
          </>
        </RemotePeerAvatar>
      </div>
    </div>
  );
}
