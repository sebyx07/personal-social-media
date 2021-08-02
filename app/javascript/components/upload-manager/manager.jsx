import {StrictMode} from 'react';
import {fileManagerEventBus} from '../../lib/event-bus/file-manager-event-bus';
import {getHookstateProperties} from '../../lib/hookstate/get-properties';
import {uploadManagerState} from './records/uploader';
import {useBeforeunload} from 'react-beforeunload';
import {useState} from '@hookstate/core';
import TestFileSelector from './test-file-selector';

export default function UploadManager() {
  const state = useState(uploadManagerState);
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

export function createNewUpload(subjectType, subjectId, files) {
  fileManagerEventBus.emit('new-upload', null, {files, subjectId, subjectType});
}

export function clearAllUnfinishedUploads() {
  fileManagerEventBus.emit('clear-unfinished-uploads');
}
