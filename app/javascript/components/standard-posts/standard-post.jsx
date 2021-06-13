import {
  standardReactionsCbForModelDec,
  standardReactionsCbForModelInc,
} from '../../utils/reactions/standard-reactions-cb-for-model';
import {timeAgoInWords} from '../../lib/dates/time-ago';
import DefaultPeerAvatar from '../peers/avatars/default-avatar';
import StandardPostReactions from './standard-post-reactions';
import ReactToSubject from '../reactions/react-to-subject';

export default function StandardPost({data: post}) {
  const {id, content, peer, createdAt} = post;

  function incrementReaction(cacheReaction) {
    return standardReactionsCbForModelInc(post, cacheReaction);
  }

  function decrementReaction(emoji) {
    return standardReactionsCbForModelDec(post, emoji);
  }

  return (
    <div className="bg-gray-200 my-2 p-2 rounded">
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
      <div className="my-4">
        <StandardPostReactions post={post} cbInc={incrementReaction} cbDec={decrementReaction}/>
      </div>
      <div className="flex">
        <div>
          <ReactToSubject
            baseUrl={`/posts/${id.get()}`}
            className="hover:bg-gray-100"
            cbInc={incrementReaction}
            model={post}
          />
        </div>
      </div>
    </div>
  );
}
