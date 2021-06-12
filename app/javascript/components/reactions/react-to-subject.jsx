import {axios} from '../../utils/axios';
import {useClickAway} from 'react-use';
import {useRef} from 'react';
import {useState} from '@hookstate/core';
import EmojiKb from '../util/communication/emojis/emoji-kb';
import SafeEmojiString from '../util/communication/emojis/safe-emoji-string';
import mergeStyles from '../../lib/styles/merge-styles';

export default function ReactToSubject({url, className}) {
  const ref = useRef(null);

  const state = useState({
    keyboardOpened: false,
  });

  useClickAway(ref, () => {
    if (!state.keyboardOpened.get()) return;
    state.merge({keyboardOpened: false});
  });

  function reactToSubject(emoji) {
    state.merge({keyboardOpened: false});
    axios.post(url, {reaction: {character: emoji}}).then((data) => {
      debugger;
    }).catch((e) => {
      debugger;
    });
  }

  function openKb(e) {
    e.preventDefault();
    state.merge({keyboardOpened: true});
  }

  return (
    <div className="relative" ref={ref}>
      <button onClick={openKb}
        className={mergeStyles('rounded text-white rounded border border-solid border-indigo-600 w-10 h-10 flex items-center justify-center', className)}>
        <SafeEmojiString string="👍" size={24}/>
      </button>

      <EmojiKb isOpened={state.keyboardOpened.get()} append={reactToSubject} className="absolute z-10"/>
    </div>
  );
}
