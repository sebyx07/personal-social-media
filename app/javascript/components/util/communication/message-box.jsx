import {useState} from '@hookstate/core';
import ContentEditable from 'react-contenteditable';
import EmojiKb from './emojis/emoji-kb';
import PropTypes from 'prop-types';
import mergeStyles from '../../../lib/styles/merge-styles';

export default function MessageBox({submit, input = '', className, disabled}) {
  const state = useState({
    inputHtml: input,
    keyboardOpened: false,
  });

  function saveWrapper(e) {
    e.preventDefault();
    submit({
      clear: () => {
        state.merge({
          inputHtml: '',
        });
      },
      data: {inputHtml: state.inputHtml.get()},
    });
  }

  function handleChange(e) {
    state.merge({
      inputHtml: e.target.value,
    });
  }

  function handlePaste(e) {
    e.preventDefault();

    const text = (e.originalEvent || e).clipboardData.getData('text/plain');
    document.execCommand('insertHTML', false, text);
  }

  function toggleEmojiKeyboard(e) {
    e.preventDefault();
    e.stopPropagation();
    state.merge((s) => {
      return {
        keyboardOpened: !s.keyboardOpened,
      };
    });
  }

  return (
    <form onSubmit={saveWrapper} className="flex">
      <div className={mergeStyles('flex flex-1 w-1/2', className)}>
        <ContentEditable className="p-2 focus:outline-none flex-1 w-1/2"
          html={state.inputHtml.get()}
          onChange={handleChange}
          disabled={disabled}
          onPaste={handlePaste}
        />

        <div className="relative">
          <button onClick={toggleEmojiKeyboard}>
            emoji
          </button>

          <EmojiKb isOpened={state.keyboardOpened.get()} append={() => {}} className="absolute z-10"/>
        </div>
      </div>

      <button className="themed ml-2" disabled={disabled}>
        Submit
      </button>
    </form>
  );
}

MessageBox.propTypes = {
  disabled: PropTypes.bool.isRequired,
  submit: PropTypes.func.isRequired,
};
