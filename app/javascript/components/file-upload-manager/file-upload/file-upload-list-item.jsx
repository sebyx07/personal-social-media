import ProgressBar from '../../util/loaders/progress-bar';
import PropTypes from 'prop-types';

export default function FileUploadListItem({uploadFile}) {
  const {fileName, progress, cancelUpload} = uploadFile;

  function cancelFile(e) {
    e.preventDefault();
    cancelUpload();
  }

  return (
    <div className="flex justify-between items-center border-solid border-b border-white py-2 px-1">
      <div className="pr-6 w-1/6">
        {fileName} ({progress}%)
      </div>

      <div className="flex-1">
        <ProgressBar progress={progress}>
          ok
        </ProgressBar>
      </div>

      <div className="pl-6">
        <button onClick={cancelFile} className="hover:bg-blue-600 rounded p-2">
          Cancel
        </button>
      </div>
    </div>
  );
}

FileUploadListItem.propTypes = {
  uploadFile: PropTypes.object.isRequired,
};