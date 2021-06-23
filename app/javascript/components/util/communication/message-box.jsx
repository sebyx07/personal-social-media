import './messagae-box.scss';
import 'emoji-mart/css/emoji-mart.css';
import {emojiPlugin} from '../../../utils/text-with-emoji';
import {useCallback, useRef, useState} from 'react';
import {useClickAway} from 'react-use';
import Editor from 'draft-js-plugins-editor';
import SafeEmojiString from './emojis/safe-emoji-string';

const {Picker} = emojiPlugin;

export default function MessageBox({editorState, onChange, placeholder}) {
  const ref = useRef(null);
  const [state, setState] = useState({
    pickerOpened: false,
  });

  const editorRef = useCallback((node) => {
    node.focus();
  }, []);

  useClickAway(ref, () => {
    if (!state.pickerOpened) return;
    setState({
      ...state,
      pickerOpened: false,
    });
  });

  function openPicker(e) {
    e.preventDefault();

    setState({
      ...state,
      pickerOpened: true,
    });
  }

  return (
    <div className="flex">
      <div className="border border-solid border-gray-400 p-2 flex-1 message-box">
        <Editor
          ref={editorRef}
          editorState={editorState}
          onChange={onChange}
          plugins={[emojiPlugin]}
          placeholder={placeholder}
        />
      </div>
      <div className="ml-2 relative">
        <button className="themed" onClick={openPicker}>
          <SafeEmojiString string="😀" size={24}/>
        </button>

        {
          state.pickerOpened && <div className="absolute top-0 right-0" ref={ref}>
            <Picker
              perLine={7}
              showPreview={false}
            />
          </div>
        }
      </div>
    </div>
  );
}
