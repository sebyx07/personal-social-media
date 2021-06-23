import './messagae-box.scss';
import 'emoji-mart/css/emoji-mart.css';
import {emojiPlugin} from '../../../utils/text-with-emoji';
import {useClickAway} from 'react-use';
import {useRef, useState} from 'react';
import Editor from 'draft-js-plugins-editor';
import SafeEmojiString from './emojis/safe-emoji-string';

const {Picker} = emojiPlugin;

export default function MessageBox({editorState, onChange}) {
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
    <div className="flex">
      <div className="border border-solid border-gray-400 p-2 flex-1 message-box">
        <Editor
          editorState={editorState}
          onChange={onChange}
          plugins={[emojiPlugin]}
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


// import {useState} from '@hookstate/core';
// import ContentEditable from 'react-contenteditable';
// import EmojiKb from './emojis/emoji-kb';
// import PropTypes from 'prop-types';
// import mergeStyles from '../../../lib/styles/merge-styles';
// import {useMemo, useRef} from "react";
// import MessageBoxKeyboard from "./message-box-keyboard";
// import {getCursorEditableDiv} from "../../../lib/input/get-cursor-editable-div";
//
// export default function MessageBox({submit, input = '', className, disabled}) {
//   const ref = useRef();
//   const state = useState({
//     inputHtml: input,
//     keyboardOpened: false,
//   });
//
//   function saveWrapper(e) {
//     e.preventDefault();
//     submit({
//       clear: () => {
//         state.merge({
//           inputHtml: '',
//         });
//       },
//       data: {inputHtml: state.inputHtml.get()},
//     });
//   }
//
//   function handleKeyDown(e){
//     const position = getCursorEditableDiv(e.nativeEvent.target);
//     console.log(position);
//   }
//
//   function handleChange(e) {
//     handleKeyDown(e);
//     state.merge({
//       inputHtml: e.target.value,
//     });
//   }
//
//   function handlePaste(e) {
//     e.preventDefault();
//
//     const text = (e.originalEvent || e).clipboardData.getData('text/plain');
//     document.execCommand('insertHTML', false, text);
//   }
//
//   function appendEmojiHtml(html){
//     state.merge((s) => {
//       return {
//         inputHtml: s.inputHtml + html
//       }
//     })
//   }
//
//   return (
//     <form onSubmit={saveWrapper} className="flex">
//       <div className={mergeStyles('flex flex-1 w-1/2', className)}>
//         <ContentEditable ref={ref}
//           className="p-2 focus:outline-none flex-1 w-1/2"
//           html={state.inputHtml.get()}
//           onChange={handleChange}
//           disabled={disabled}
//           onPaste={handlePaste}
//           onKeyDown={handleKeyDown}
//         />
//
//         <div>
//           <MessageBoxKeyboard appendEmojiHtml={appendEmojiHtml}/>
//         </div>
//       </div>
//
//       <button className="themed ml-2" disabled={disabled}>
//         Submit
//       </button>
//     </form>
//   );
// }
//
// MessageBox.propTypes = {
//   disabled: PropTypes.bool.isRequired,
//   submit: PropTypes.func.isRequired,
// };
