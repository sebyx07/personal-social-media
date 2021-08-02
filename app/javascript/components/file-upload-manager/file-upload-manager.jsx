import {StrictMode} from 'react';
import {fileUploadManagerState} from './records/file-upload-manager-record';
import {getHookstateProperties} from '../../lib/hookstate/get-properties';
import {useBeforeunload} from 'react-beforeunload';
import {useState} from '@hookstate/core';
import TestFileSelector from './test-file-selector';

export default function FileUploadManager() {
  const state = useState(fileUploadManagerState);
  const {status: uploaderStatus} = getHookstateProperties(state, 'status');

  useBeforeunload((e) => {
    if (uploaderStatus === 'pending') return;
    e.preventDefault();

    return 'please finish the upload before leaving';
  });

  return (
    <StrictMode>
      <TestFileSelector>
        <div>
          {
            uploaderStatus
          }
        </div>

        <div>
          Upload manager
        </div>
      </TestFileSelector>
    </StrictMode>
  );
}
