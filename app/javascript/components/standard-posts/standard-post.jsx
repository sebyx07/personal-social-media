import {timeAgoInWords} from '../../lib/dates/time-ago';
import DefaultPeerAvatar from '../peers/avatars/default-avatar';

export default function StandardPost({data: {id, content, peer, createdAt}}) {
  return (
    <div className="bg-gray-200 hover:bg-gray-300 my-2 p-2 rounded">
      <div>
        <DefaultPeerAvatar peer={peer}>
          {id.get()}
          <div>
            {timeAgoInWords(createdAt.get())}
          </div>
        </DefaultPeerAvatar>
      </div>
      <div>
        {content.get()}
      </div>
    </div>
  );
}
