import {uniqBy} from 'lodash';
import {useRef, useState} from 'react';
import MessageBoxAttachment, {buildAttachmentRecord} from './message-box-form-with-attachments/attachment';
import MessageBoxForm from './message-box-form';
import PropTypes from 'prop-types';

export default function MessageBoxFormWithAttachments({
  submit, messageBoxClassName, clearOnSubmit, placeholder, buttonText,
}) {
  const inputRef = useRef();
  const [state, setState] = useState({
    selectedFileRecords: [],
  });

  function openFilePicker(e) {
    e.preventDefault();
    inputRef.current.click();
  }

  function selectFiles(e) {
    e.preventDefault();
    const newSelectedFiles = Array.from(e.target.files).map((file) => buildAttachmentRecord(file));
    const selectedFileRecords = uniqBy(state.selectedFileRecords.concat(newSelectedFiles), 'key');
    setState({...state, selectedFileRecords});
    e.target.value = '';
  }

  return (
    <div>
      <MessageBoxForm
        submit={submit}
        messageBoxClassName={messageBoxClassName}
        clearOnSubmit={clearOnSubmit}
        placeholder={placeholder}
        buttonText={buttonText}
        extraButtons={<button onClick={openFilePicker} className="ml-1">
          <i className="fas fa-paperclip"/>
        </button>}
        extraOutput={<div className="flex flex-wrap pt-1 bg-gray-400">
          {
            state.selectedFileRecords.map((attachmentRecord) => {
              return (
                <MessageBoxAttachment attachmentRecord={attachmentRecord} key={attachmentRecord.key}/>
              );
            })
          }
        </div>}
      />
      <input ref={inputRef} type="file" className="hidden" multiple onChange={selectFiles}/>
    </div>
  );
}

MessageBoxFormWithAttachments.propTypes = {
  buttonText: PropTypes.string.isRequired,
  clearOnSubmit: PropTypes.bool,
  defaultText: PropTypes.string,
  messageBoxClassName: PropTypes.string,
  placeholder: PropTypes.string,
  submit: PropTypes.func.isRequired,
};
