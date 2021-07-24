import {ContentState, EditorState, convertToRaw} from 'draft-js';
import {useState} from 'react';
import MessageBox from './message-box';
import PropTypes from 'prop-types';
import mergeStyles from '../../../lib/styles/merge-styles';
const {createFromText} = ContentState;

export default function MessageBoxForm({
  clearOnSubmit= true,
  submit,
  messageBoxClassName,
  placeholder,
  defaultText='',
  buttonText,
  extraButtons,
  extraOutput,
}) {
  const [state, setState] = useState({
    disabled: false,
    editorState: EditorState.createWithContent(createFromText(defaultText)),
  });

  function onChange(editorState) {
    setState({
      ...state,
      editorState,
    });
  }

  async function save(e) {
    e.preventDefault();

    const content = convertToRaw(state.editorState.getCurrentContent());
    const text = content.blocks.map((block) => {
      return block.text;
    }).join(' ').replace(/\s+/g, ' ').trim();

    setState({...state, disabled: true});
    try {
      await submit(text);
      let change = {...state, disabled: false};
      if (clearOnSubmit) {
        change = {...change, editorState: EditorState.createEmpty()};
      }

      setState(change);
    } catch (e) {
      console.log(e);
      setState({...state, disabled: false});
    }
  }

  return (
    <div>
      <form className="flex" onSubmit={save}>
        <div className={mergeStyles('flex-1 w-1/3', state.disabled ? 'pointer-events-none' : '')}>
          <MessageBox
            editorState={state.editorState}
            onChange={onChange}
            placeholder={placeholder}
            messageBoxClassName={messageBoxClassName}
            extraButtons={extraButtons}
            extraOutput={extraOutput}
          />
        </div>
        <div>
          <button className="themed ml-2">
            {buttonText}
          </button>
        </div>
      </form>
    </div>
  );
}


MessageBoxForm.propTypes = {
  buttonText: PropTypes.string.isRequired,
  clearOnSubmit: PropTypes.bool,
  defaultText: PropTypes.string,
  extraButtons: PropTypes.element,
  extraOutput: PropTypes.element,
  messageBoxClassName: PropTypes.string,
  placeholder: PropTypes.string,
  submit: PropTypes.func.isRequired,
};
