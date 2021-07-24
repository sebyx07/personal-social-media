import {registerRealTimeRemotePost, unRegisterRealTimeRemotePost} from '../../realtime/register-record/register-remote-post';
import {
  standardReactionsCbForModelDec,
  standardReactionsCbForModelInc,
} from '../../utils/reactions/standard-reactions-cb-for-model';
import {timeAgoInWords} from '../../lib/dates/time-ago';
import {useEffect} from 'react';
import {useState} from '@hookstate/core';
import CommentsList from '../comments/comments-list';
import DefaultPeerAvatar from '../peers/avatars/default-avatar';
import ReactToSubject from '../reactions/react-to-subject';
import StandardPostNewComment from './standard-post-new-comment';
import StandardPostReactions from './standard-post-reactions';

export default function StandardPost({data: post}) {
  useEffect(() => {
    const subscriptionId = registerRealTimeRemotePost(post);
    return () => unRegisterRealTimeRemotePost(post, subscriptionId);
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

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
        <DefaultPeerAvatar peer={post.peer}>
          <div>
            {timeAgoInWords(post.createdAt.get())}
          </div>
        </DefaultPeerAvatar>
      </div>
      <div>
        {post.content.message.get()}
      </div>
      <div className="my-4">
        <StandardPostReactions post={post} cbInc={incrementReaction} cbDec={decrementReaction}/>
      </div>
      <div className="flex items-center">
        <div>
          <ReactToSubject
            baseUrl={`/posts/${post.id.get()}`}
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
          <StandardPostNewComment post={post}/>
        </div>
      }

      <div className="pt-2">
        <CommentsList latestComments={post.latestComments} comments={post.comments} hostOfCommentPeer={post.peer}/>
      </div>
    </div>
  );
}
