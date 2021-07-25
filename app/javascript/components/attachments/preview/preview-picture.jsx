import {humanReadableBytes} from '../../../utils/numbers/human-readable-bytes';
import Modal from '../../util/modal';
import PropTypes from 'prop-types';

export default function PreviewPictureAttachment({file, url, isOpen, close}) {
  if (!isOpen) return null;
  const objectUrl = url || URL.createObjectURL(file);

  return (
    <Modal isOpen={isOpen} close={close}>
      <div className="flex items-center h-full flex-wrap">
        {
          file && <div className="flex-1 text-center my-1">
            {file.name} - {humanReadableBytes(file.size)}
          </div>
        }

        <img src={objectUrl} alt="preview image attachment" className="w-full"/>
      </div>
    </Modal>
  );
}

PreviewPictureAttachment.propTypes = {
  close: PropTypes.func.isRequired,
  file: PropTypes.object,
  isOpen: PropTypes.bool.isRequired,
  url: PropTypes.string,
};
