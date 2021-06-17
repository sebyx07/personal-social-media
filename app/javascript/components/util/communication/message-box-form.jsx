import {useState} from '@hookstate/core';
import MessageBox from './message-box';
import PropTypes from 'prop-types';

export default function MessageBoxForm({clearOnSubmit= true, submit, messageBoxClassName}) {
  const state = useState({
    disabled: false,
  });

  async function submitWrapper({data: {inputHtml}, clear}) {
    console.log(inputHtml);
    state.merge({disabled: true});
    try {
      await submit({inputHtml});
      if (clearOnSubmit) clear();
    } finally {
      state.merge({disabled: false});
    }
  }

  return (
    <MessageBox submit={submitWrapper} className={messageBoxClassName} disabled={state.disabled.get()}/>
  );
}


MessageBoxForm.propTypes = {
  clearOnSubmit: PropTypes.bool,
  submit: PropTypes.func.isRequired,
};
