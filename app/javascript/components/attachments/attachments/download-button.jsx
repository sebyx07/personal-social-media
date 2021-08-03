import PropTypes from 'prop-types';

export default function DownloadButtonAttachment({onClick}) {
  function handleClick(e) {
    e.preventDefault();
    onClick(e);
  }

  return (
    <button onClick={handleClick}>
      Download
    </button>
  );
}

DownloadButtonAttachment.propTypes = {
  onClick: PropTypes.func.isRequired,
};
