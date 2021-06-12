import {feedBackError} from '../../../utils/feedback';
import {
  standardReactionForModelCreate,
  standardReactionForModelDestroy,
} from '../../../utils/reactions/standard-reaction-for-model';
import PropTypes from 'prop-types';
import mergeStyles from '../../../lib/styles/merge-styles';

export default function ReactionCounterActionWrapper({reactionCounter, localReactionsStore, children}) {
  const character = reactionCounter.character.get();
  const {
    hasReactedCheck,
    cbDec,
    cbInc,
    baseUrl,
    modelId,
  } = localReactionsStore;
  const hasReacted = hasReactedCheck(character);
  const url = baseUrl + `/${modelId}`;
  const hasReactedClassName = hasReacted ? 'bg-gray-400 rounded' : '';

  async function increment() {
    try {
      const {data: {reaction}} = await standardReactionForModelCreate(url, character);
      cbInc(reaction);
    } catch {
      feedBackError('Unable to react');
    }
  }

  async function decrement() {
    try {
      await standardReactionForModelDestroy(url, character);
      cbDec(character);
    } catch {
      feedBackError('Unable to remove reaction');
    }
  }

  function toggleReaction() {
    if (hasReacted) return decrement();
    return increment();
  }

  return (
    <div className="p-1 w-1/6">
      <button className={mergeStyles(hasReactedClassName, 'p-1 flex justify-center items-center')} onClick={toggleReaction}>
        {children}
      </button>
    </div>
  );
}

ReactionCounterActionWrapper.propTypes = {
  children: PropTypes.element.isRequired,
  localReactionsStore: PropTypes.object.isRequired,
  reactionCounter: PropTypes.object.isRequired,
};
