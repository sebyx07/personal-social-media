import {feedBackError} from '../../utils/feedback';
import {getReactionCounterForModel} from '../../utils/reactions/standard-reactions-cb-for-model';
import {standardReactionForModelCreate} from '../../utils/reactions/standard-reaction-for-model';
import {useClickAway} from 'react-use';
import {useRef} from 'react';
import {useState} from '@hookstate/core';
import EmojiKb from '../util/communication/emojis/emoji-kb';
import PropTypes from 'prop-types';
import SafeEmojiString from '../util/communication/emojis/safe-emoji-string';
import mergeStyles from '../../lib/styles/merge-styles';

export default function ReactToSubject({baseUrl, className, cbInc, model}) {
  const ref = useRef(null);

  const state = useState({
    buttonDisabled: false,
    keyboardOpened: false,
  });

  useClickAway(ref, () => {
    if (!state.keyboardOpened.get()) return;
    state.merge({keyboardOpened: false});
  });

  async function reactToSubject(emoji) {
    state.merge({buttonDisabled: true, keyboardOpened: false});
    const reactionCounter = getReactionCounterForModel(model, emoji);
    if (reactionCounter?.hasReacted) {
      return feedBackError(`You already reacted with ${emoji}`);
    }

    try {
      const {data: {reaction}} = await standardReactionForModelCreate(baseUrl, emoji);
      cbInc(reaction);
    } catch {
      feedBackError('Unable to react');
    } finally {
      state.merge({buttonDisabled: false});
    }
  }

  function openKb(e) {
    e.preventDefault();
    state.merge({keyboardOpened: true});
  }

  return (
    <div className="relative" ref={ref}>
      <button onClick={openKb} disabled={state.buttonDisabled.get()}
        className={mergeStyles('rounded text-white rounded border border-solid border-white px-1 h-10 w-10 flex items-center justify-center', className)}>
        <SafeEmojiString string="👍" size={24} className="flex items-center justify-center"/>
      </button>

      <EmojiKb isOpened={state.keyboardOpened.get()} append={reactToSubject} className="absolute z-10"/>
    </div>
  );
}

ReactToSubject.propTypes = {
  baseUrl: PropTypes.string.isRequired,
  cbInc: PropTypes.func,
  className: PropTypes.string,
  model: PropTypes.object.isRequired,
};
