import {fileUploadManager} from './records/file-upload-manager-record';
import {useRef} from 'react';

export default function TestFileSelector({children}) {
  const inputRef= useRef();
  function selectFile(e) {
    e.preventDefault();

    inputRef.current.click();
  }

  function fileSelected(e) {
    e.preventDefault();

    const files = Array.from(e.target.files);
    e.target.value = '';
    return fileUploadManager.createUpload('Post', 1, files);
  }

  return (
    <div>
      <div>
        <button onClick={selectFile} className="bg-blue-600 p-2 mx-4 text-white">
          Select file to test upload:
        </button>
      </div>

      <div>
        <input type="file" onChange={fileSelected} className="hidden" multiple ref={inputRef}/>
      </div>

      {children}
    </div>
  );
}
