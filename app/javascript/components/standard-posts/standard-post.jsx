import {
  standardReactionsCbForModelDec,
  standardReactionsCbForModelInc,
} from '../../utils/reactions/standard-reactions-cb-for-model';
import {timeAgoInWords} from '../../lib/dates/time-ago';
import {useState} from '@hookstate/core';
import DefaultPeerAvatar from '../peers/avatars/default-avatar';
import ReactToSubject from '../reactions/react-to-subject';
import StandardPostComment from './standard-post-comment';
import StandardPostReactions from './standard-post-reactions';

export default function StandardPost({data: post}) {
  const {id, content, peer, createdAt} = post;
  const state = useState({
    showNewComment: false,
  });

  function incrementReaction(cacheReaction) {
    return standardReactionsCbForModelInc(post, cacheReaction);
  }

  function decrementReaction(emoji) {
    return standardReactionsCbForModelDec(post, emoji);
  }

  function toggleShowNewComment(e) {
    e.preventDefault();

    state.merge((s) => {
      return {
        showNewComment: !s.showNewComment,
      };
    });
  }

  return (
    <div className="bg-gray-200 my-2 p-2 rounded">
      <div>
        <DefaultPeerAvatar peer={peer}>
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
      <div className="flex items-center">
        <div>
          <ReactToSubject
            baseUrl={`/posts/${id.get()}`}
            className="hover:bg-gray-100"
            cbInc={incrementReaction}
            model={post}
          />
        </div>

        <div className="flex-1 text-center">
          <button className="border border-solid border-gray-400 rounded px-6 py-1 hover:bg-gray-300" onClick={toggleShowNewComment}>
            Comment
          </button>
        </div>
      </div>

      {
        state.showNewComment.get() && <div className="py-2">
          <StandardPostComment post={post}/>
        </div>
      }
    </div>
  );
}
