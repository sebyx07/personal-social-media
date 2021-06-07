import {timeAgoInWords} from '../../lib/dates/time-ago';
import DefaultPeerAvatar from '../peers/avatars/default-avatar';
import PostReactions from '../reactions/post-reactions';
import ToggleReaction from '../reactions/toggle-reaction';

export default function StandardPost({data: post}) {
  const {id, content, peer, createdAt} = post;

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
      <div>
        <PostReactions post={post}/>
      </div>
      <div className="flex">
        <div>
          <ToggleReaction url={`/posts/${id.get()}/reactions`} />
        </div>
      </div>
    </div>
  );
}
