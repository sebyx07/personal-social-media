import {clearAllUnfinishedUploads, createNewUpload} from './manager';
import {uploadManagerState} from './records/uploader';
import {useRef} from 'react';
import {useState} from '@hookstate/core';

export default function TestFileSelector({children}) {
  const state = useState(uploadManagerState);
  const inputRef= useRef();
  function selectFile(e) {
    e.preventDefault();

    inputRef.current.click();
  }

  function fileSelected(e) {
    e.preventDefault();

    createNewUpload('Post', 7, e.target.files);
    e.target.value = '';
  }

  function _clearAllUnfinishedUploads(e) {
    e.preventDefault();
    clearAllUnfinishedUploads();
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
