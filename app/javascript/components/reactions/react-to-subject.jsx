import {axios} from '../../utils/axios';
import {useClickAway} from 'react-use';
import {useRef} from 'react';
import {useState} from '@hookstate/core';
import EmojiKb from '../util/communication/emojis/emoji-kb';

export default function ReactToSubject({url}) {
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
    <div className="relative">
      <button onClick={openKb} className="default">
        😊
      </button>

      <EmojiKb isOpened={state.keyboardOpened.get()} append={reactToSubject} className="absolute z-10"/>
    </div>
  );
}
