import PropTypes from 'prop-types';
import ReactionCounter from './reactions-counters/reaction-counter';
import ReactionCounterActionWrapper from './reactions-counters/reaction-counter-action-wrapper';
import mergeStyles from '../../lib/styles/merge-styles';

export default function ReactionCounters({localReactionsStore}) {
  const {reactionCounters, countersListStyle} = localReactionsStore;

  const displayedReactionCounters = reactionCounters.filter((counter) => {
    return counter.reactionsCount.get() > 0;
  });

  return (
    <div className={mergeStyles('flex flex-wrap', countersListStyle)}>
      {
        displayedReactionCounters.map((reactionCounter) => {
          return (
            <ReactionCounterActionWrapper key={reactionCounter.character.get()}
              reactionCounter={reactionCounter}
              localReactionsStore={localReactionsStore}>
              <ReactionCounter reactionCounter={reactionCounter} localReactionsStore={localReactionsStore}/>
            </ReactionCounterActionWrapper>
          );
        })
      }
    </div>
  );
}

ReactionCounters.propTypes = {
  localReactionsStore: PropTypes.shape({
    baseUrl: PropTypes.string.isRequired,
    cbDec: PropTypes.func.isRequired,
    cbInc: PropTypes.func.isRequired,
    counterEmojiSize: PropTypes.number.isRequired,
    counterTextStyle: PropTypes.object.isRequired,
    countersListStyle: PropTypes.string.isRequired,
    modelId: PropTypes.number.isRequired,
    reactionCounters: PropTypes.array.isRequired,
    reactionsClassName: PropTypes.string.isRequired,
    reactionsWrapperEachClassName: PropTypes.string.isRequired,
  }).isRequired,
};
