import {take} from 'lodash';
import {useState} from '@hookstate/core';
import HistoryOfReactions from '../reactions/history-of-reactions';
import PropTypes from 'prop-types';
import ReactionCounters from '../reactions/reaction-counters';

export default function StandardPostReactions({post, cbInc, cbDec}) {
  const state = useState({
    isExpanded: false,
    showHistory: false,
  });
  const {reactionCounters} = post;
  const canBeExpanded = reactionCounters.length > 6;

  function toggleExpanded() {
    if (!canBeExpanded) return;

    return state.merge((s) => {
      return {
        isExpanded: !s.isExpanded,
      };
    });
  }

  const isExpanded = state.isExpanded.get();
  const displayedReactionCounters = isExpanded ? reactionCounters : take(reactionCounters, 6);
  const countersListStyle = isExpanded ? 'justify-start' : 'justify-between';
  const counterEmojiSize = isExpanded ? 25 : 30;
  const counterTextStyle = isExpanded ? {fontSize: '1rem', marginLeft: '2px'} : {fontSize: '1.2rem', marginLeft: '2px'};
  const modelId = post.id.get();

  const localReactionsStore = {
    baseUrl: '/posts',
    cbDec,
    cbInc,
    counterEmojiSize,
    counterTextStyle,
    countersListStyle: countersListStyle,
    modelId: modelId,
    reactionCounters: displayedReactionCounters,
    reactionsClassName: 'hover:bg-gray-100',
    reactionsWrapperEachClassName: 'p-1',
  };

  if (displayedReactionCounters.length < 1) return null;

  return (
    <>
      <div className="p-1 rounded border border-solid border-gray-400">
        <ReactionCounters localReactionsStore={localReactionsStore}/>

        <div className="flex justify-between items-end">
          <button className="text-xs" onClick={() => state.merge({showHistory: true})}>
            Show history of reactions
          </button>

          {
            canBeExpanded && <div>
              <button className="text-xs mt-2" onClick={toggleExpanded}>
                {
                  isExpanded ? 'Click to retract' : 'Click to show all'
                }
              </button>
            </div>
          }
        </div>
      </div>
      <HistoryOfReactions
        isOpened={state.showHistory.get()}
        modelId={modelId} modelType="Post"
        close={() => state.merge({showHistory: false})}
      />
    </>
  );
}

StandardPostReactions.propTypes = {
  cbDec: PropTypes.func.isRequired,
  cbInc: PropTypes.func.isRequired,
  post: PropTypes.object.isRequired,
};
