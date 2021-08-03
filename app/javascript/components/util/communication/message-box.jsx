import './messagae-box.scss';
import 'emoji-mart/css/emoji-mart.css';
import {emojiPlugin} from '../../../utils/text-with-emoji';
import {useClickAway} from 'react-use';
import {useRef, useState} from 'react';
import Editor from '@draft-js-plugins/editor';
import SafeEmojiString from './emojis/safe-emoji-string';
import mergeStyles from '../../../lib/styles/merge-styles';

const {Picker} = emojiPlugin;

export default function MessageBox({editorState, onChange, placeholder, messageBoxClassName, extraOutput, extraButtons}) {
  const ref = useRef(null);
  const [state, setState] = useState({
    pickerOpened: false,
  });

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
    <div className={mergeStyles('border border-solid border-gray-400 p-2 message-box', messageBoxClassName)}>
      <div className="flex">
        <div className="flex-1 w-1/3">
          <Editor
            editorState={editorState}
            onChange={onChange}
            plugins={[emojiPlugin]}
            placeholder={placeholder}
          />
        </div>
        <div className="ml-2 relative">
          <>
            <div className="flex items-center">
              <button onClick={openPicker}>
                <SafeEmojiString string="😀" size={24}/>
              </button>
              {extraButtons}
            </div>

            {
              state.pickerOpened && <div className="absolute top-0 left-0" ref={ref}>
                <Picker
                  perLine={7}
                  showPreview={false}
                />
              </div>
            }
          </>
        </div>
      </div>
      {extraOutput}
    </div>
  );
}
