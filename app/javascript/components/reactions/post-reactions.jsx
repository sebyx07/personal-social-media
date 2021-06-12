import PropTypes from 'prop-types';
import ReactionCounters from './reaction-counters';

export default function PostReactions({post, cbInc, cbDec, hasReactedCheck}) {
  const {reactionCounters} = post;
  const localReactionsStore = {
    baseUrl: '/posts',
    cbDec,
    cbInc,
    hasReactedCheck,
    modelId: post.id.get(),
    reactionCounters,
    reactionsClassName: 'hover:bg-gray-100',
  };

  return (
    <div>
      <ReactionCounters localReactionsStore={localReactionsStore}/>
    </div>
  );
}

PostReactions.propTypes = {
  cbDec: PropTypes.func.isRequired,
  cbInc: PropTypes.func.isRequired,
  hasReactedCheck: PropTypes.func.isRequired,
  post: PropTypes.object.isRequired,
};
