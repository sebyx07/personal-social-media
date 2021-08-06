import {StrictMode} from 'react';
import {fileUploadManagerState} from './file-upload-manager-state';
import {getHookstateProperties} from '../../lib/hookstate/get-properties';
import {useBeforeunload} from 'react-beforeunload';
import {useState} from '@hookstate/core';
import FileUploadList from './file-upload/file-upload-list';
import TestFileSelector from './test-file-selector';

export default function FileUploadManager() {
  const state = useState(fileUploadManagerState);
  const {show, message} = getHookstateProperties(state, 'show', 'message');
  const {subjectId, subjectType} = getHookstateProperties(state.uploadSubject, 'subjectId', 'subjectType');

  useBeforeunload((e) => {
    if (!show) return;
    e.preventDefault();

    return 'please finish the upload before leaving';
  });

  return (
    <StrictMode>
      <TestFileSelector>
        {
          show && <div className="bg-blue-500 text-white fixed bottom-0 w-full px-2 py-4">
            <div className="flex-wrap flex">
              <div className="px-2">
                <h3 className="italic font-bold text-lg text-center">
                  Upload manager
                </h3>

                {
                  subjectId && <div>
                    Handling upload for {subjectType}#{subjectId}
                  </div>
                }

                {
                  message && <div>
                    {message}
                  </div>
                }
              </div>

              <div className="flex-1 overflow-y-auto h-48">
                <FileUploadList state={state}/>
              </div>
            </div>
          </div>
        }
      </TestFileSelector>
    </StrictMode>
  );
}