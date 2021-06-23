import {useState} from 'react';
import EditorState from 'draft-js/lib/EditorState';
import MessageBox from './message-box';
import PropTypes from 'prop-types';

export default function MessageBoxForm({clearOnSubmit= true, submit, messageBoxClassName}) {
  const [state, setState] = useState({
    disabled: false,
    editorState: EditorState.createEmpty(),
  });

  function onChange(editorState) {
    setState({
      ...state,
      editorState,
    });
  }

  return (
    <MessageBox editorState={state.editorState} onChange={onChange}/>
  );
}


MessageBoxForm.propTypes = {
  clearOnSubmit: PropTypes.bool,
  submit: PropTypes.func.isRequired,
};
