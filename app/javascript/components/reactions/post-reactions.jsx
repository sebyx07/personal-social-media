import {take} from 'lodash';
import {useState} from '@hookstate/core';
import PropTypes from 'prop-types';
import ReactionCounters from './reaction-counters';

export default function PostReactions({post, cbInc, cbDec}) {
  const state = useState({
    isExpanded: false,
  });

  function toggleExpanded() {
    return state.merge((s) => {
      return {
        isExpanded: !s.isExpanded,
      };
    });
  }

  const {reactionCounters} = post;
  const isExpanded = state.isExpanded.get();
  const displayedReactionCounters = isExpanded ? reactionCounters : take(reactionCounters, 6);
  const countersListStyle = isExpanded ? 'justify-start' : 'justify-between';
  const counterEmojiSize = isExpanded ? 25 : 30;
  const counterTextStyle = isExpanded ? {fontSize: '1rem', marginLeft: '2px'} : {fontSize: '1.2rem', marginLeft: '2px'};

  const localReactionsStore = {
    baseUrl: '/posts',
    cbDec,
    cbInc,
    counterEmojiSize,
    counterTextStyle,
    countersListStyle: countersListStyle,
    modelId: post.id.get(),
    reactionCounters: displayedReactionCounters,
    reactionsClassName: 'hover:bg-gray-100',
    reactionsWrapperEachClassName: 'p-1',
  };

  if (displayedReactionCounters.length < 1) return null;

  return (
    <div className="p-1 rounded border border-solid border-gray-400" onClick={toggleExpanded}>
      <ReactionCounters localReactionsStore={localReactionsStore}/>
    </div>
  );
}

PostReactions.propTypes = {
  cbDec: PropTypes.func.isRequired,
  cbInc: PropTypes.func.isRequired,
  post: PropTypes.object.isRequired,
};
