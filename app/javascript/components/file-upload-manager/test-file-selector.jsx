import {fileUploadManager, fileUploadManagerState} from './records/file-upload-manager-record';
import {useRef} from 'react';
import {useState} from '@hookstate/core';

export default function TestFileSelector({children}) {
  const state = useState(fileUploadManagerState);
  const inputRef= useRef();
  function selectFile(e) {
    e.preventDefault();

    inputRef.current.click();
  }

  function fileSelected(e) {
    e.preventDefault();

    fileUploadManager.createUpload('Post', 7, e.target.files);
    e.target.value = '';
  }

  function _clearAllUnfinishedUploads(e) {
    e.preventDefault();
  }

  return (
    <div>
      <div>
        {
          state.status.get() === 'pending' &&
            <button onClick={selectFile} className="bg-blue-600 p-2 mx-4 text-white">
              Select file to test upload:
            </button>
        }

        <button onClick={_clearAllUnfinishedUploads} className="bg-blue-600 p-2 mx-4 text-white ml-6">
          Clear unfinished uploads
        </button>
      </div>

      <div>
        <input type="file" onChange={fileSelected} className="hidden" multiple ref={inputRef}/>
      </div>

      {children}
    </div>
  );
}
