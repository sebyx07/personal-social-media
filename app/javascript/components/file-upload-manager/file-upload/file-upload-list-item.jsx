import {fileUploadManager} from '../records/file-upload-manager-record';
import {getHookstateProperties} from '../../../lib/hookstate/get-properties';
import {humanReadableBytes} from '../../../lib/string/human-readable-bytes';
import {humanReadableSeconds} from '../../../lib/string/human-readable-seconds';
import {isEmpty} from 'lodash';
import ProgressBar from '../../util/loaders/progress-bar';
import PropTypes from 'prop-types';
import mergeStyles from '../../../lib/styles/merge-styles';

export default function FileUploadListItem({uploadFile}) {
  const {fileName, progress, sha256, message, status, currentSpeed, etaSeconds, uploadedAlreadyBytes, size} = getHookstateProperties(uploadFile, 'fileName', 'progress', 'sha256', 'message', 'status', 'currentSpeed', 'etaSeconds', 'uploadedAlreadyBytes', 'size');

  function cancelFile(e) {
    e.preventDefault();
    fileUploadManager.cancelUpload(sha256);
  }

  let hideCancel = '';
  if (isEmpty(sha256)) {
    hideCancel = 'hidden';
  }
  if (status === 'ready') {
    hideCancel = 'hidden';
  }

  return (
    <div className="flex justify-between items-center border-solid border-b border-white py-2 px-1">
      <div className="pr-6 w-1/6">
        {fileName} ({progress}%)
      </div>

      <div className="flex-1 flex-col">
        {
          currentSpeed && <div className="flex justify-between">
            <div>
              {humanReadableBytes(currentSpeed)}/s
            </div>
            <div>
              {humanReadableSeconds(etaSeconds)} remaining
            </div>
            <div>
              Uploaded {humanReadableBytes(uploadedAlreadyBytes)}/ {humanReadableBytes(size)}
            </div>
          </div>
        }

        <ProgressBar progress={progress}>
          <div>
            {message}
          </div>
        </ProgressBar>
        {
          sha256 && <div className="text-center">
            (sha256) {sha256}
          </div>
        }
      </div>

      <div className="pl-6">
        <button onClick={cancelFile} className={mergeStyles('hover:bg-blue-600 rounded p-2', hideCancel)}>
          Cancel
        </button>
      </div>
    </div>
  );
}

FileUploadListItem.propTypes = {
  uploadFile: PropTypes.object.isRequired,
};