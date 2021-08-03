import {humanReadableBytes} from '../../../utils/numbers/human-readable-bytes';
import {useEffect, useState} from 'react';
import Modal from '../../util/modal';
import PropTypes from 'prop-types';

export default function PreviewPictureAttachment({file, url, isOpen, close}) {
  const [state, setState] = useState({objectUrl: url});

  useEffect(() => {
    if (state.objectUrl) return;

    const newObjectUrl = URL.createObjectURL(file);
    setState((s) => {
      return {
        ...s,
        objectUrl: newObjectUrl,
      };
    });

    return () => URL.revokeObjectURL(newObjectUrl);
  }, [file]); // eslint-disable-line react-hooks/exhaustive-deps
  if (!isOpen) return null;

  const {objectUrl} = state;

  return (
    <Modal isOpen={isOpen} close={close}>
      <div className="flex items-center h-full flex-wrap">
        {
          file && <div className="flex-1 text-center my-1">
            {file.name} - {humanReadableBytes(file.size)}
          </div>
        }

        {
          objectUrl &&
            <img src={objectUrl} alt="preview image attachment" className="w-full"/>
        }
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
