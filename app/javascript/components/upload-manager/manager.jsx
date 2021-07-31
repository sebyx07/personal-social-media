import {StrictMode} from 'react';
import {uploader} from './records/uploader';
import {useState} from '@hookstate/core';


export default function UploadManager() {
  const state = useState({
    status: uploader.initialStatus(),
  });

  return (
    <StrictMode>
      {
        state && <div>
          upload manager
        </div>
      }
    </StrictMode>
  );
}
