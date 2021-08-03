import {useDecryptVariant} from '../hooks/attachments/use-decrypt-variant';
import {useState} from 'react';
import AttachmentModalOriginal from './attachments/modal-original';
import DecryptedVariant from './variants/decrypted-variant';
import Modal from '../util/modal';
import PropTypes from 'prop-types';

export default function Attachment({contentType, variants, defaultVariant, imageOptions, modal, fileName}) {
  const {decryptedVariantFile} = useDecryptVariant(variants, defaultVariant, contentType);
  const [state, setState] = useState({modalIsOpened: false});
  if (!decryptedVariantFile) return null;

  function close() {
    setState((s) => {
      return {...s, modalIsOpened: false};
    });
  }

  function openModal(e) {
    e.preventDefault();
    setState((s) => {
      return {...s, modalIsOpened: true};
    });
  }

  return (
    <>
      <DecryptedVariant decryptedVariantFile={decryptedVariantFile} imageOptions={imageOptions} fileName={fileName}/>
      {
        modal && <>
          <button className="absolute bottom-0 right-0 hover:bg-gray-100 p-2" onClick={openModal}>
            <i className="fa fa-search-plus fa-3x" aria-hidden="true"/>
          </button>

          <Modal isOpen={state.modalIsOpened} close={close}>
            <div className="flex items-center h-full flex-wrap">
              <AttachmentModalOriginal imageOptions={imageOptions} fileName={fileName} variants={variants} contentType={contentType}/>
            </div>
          </Modal>
        </>
      }
    </>
  );
}

Attachment.propTypes = {
  contentType: PropTypes.string.isRequired,
  defaultVariant: PropTypes.oneOf(['auto', 'original', 'small']).isRequired,
  fileName: PropTypes.string.isRequired,
  imageOptions: PropTypes.shape({
    className: PropTypes.string,
    style: PropTypes.object,
  }).isRequired,
  modal: PropTypes.bool.isRequired,
  variants: PropTypes.object.isRequired,
};
