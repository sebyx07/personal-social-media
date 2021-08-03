import PropTypes from 'prop-types';

export default function DownloadButtonAttachment({onClick}) {
  function handleClick(e) {
    e.preventDefault();
    onClick(e);
  }

  return (
    <div className="p-3 flex-1 flex justify-center">
      <button onClick={handleClick} className="p-2 bg-blue-500 hover:bg-blue-600 rounded shadow-inner text-white text-lg">
        Download
      </button>
    </div>
  );
}

DownloadButtonAttachment.propTypes = {
  onClick: PropTypes.func.isRequired,
};
