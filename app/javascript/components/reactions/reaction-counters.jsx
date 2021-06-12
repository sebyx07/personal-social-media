import PropTypes from 'prop-types';
import ReactionCounter from './reactions-counters/reaction-counter';
import ReactionCounterActionWrapper from './reactions-counters/reaction-counter-action-wrapper';

export default function ReactionCounters({localReactionsStore}) {
  const {reactionCounters} = localReactionsStore;

  const displayedReactionCounters = reactionCounters.filter((counter) => {
    return counter.reactionsCount.get() > 0;
  });

  return (
    <div className="flex flex-wrap">
      {
        displayedReactionCounters.map((reactionCounter) => {
          return (
            <ReactionCounterActionWrapper key={reactionCounter.character.get()}
              reactionCounter={reactionCounter}
              localReactionsStore={localReactionsStore}>
              <ReactionCounter reactionCounter={reactionCounter}/>
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
    hasReactedCheck: PropTypes.func.isRequired,
    modelId: PropTypes.number.isRequired,
    reactionCounters: PropTypes.array.isRequired,
    reactionsClassName: PropTypes.string.isRequired,
  }).isRequired,
};
