import {timeAgoInWords} from '../../lib/dates/time-ago';
import DefaultPeerAvatar from '../peers/avatars/default-avatar';

export default function StandardPost({post: {content, peer, createdAt}}) {
  return (
    <div className="bg-gray-200 hover:bg-gray-300 my-2 p-2 rounded">
      <div>
        <DefaultPeerAvatar peer={peer}>
          {timeAgoInWords(createdAt.get())}
        </DefaultPeerAvatar>
      </div>
      <div>

      </div>
      {content.get()}
    </div>
  );
}
