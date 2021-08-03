import {useDecryptVariant} from '../hooks/attachments/use-decrypt-variant';
import DecryptedVariant from './variants/decrypted-variant';
import PropTypes from 'prop-types';

export default function Attachment({contentType, variants, defaultVariant, imageOptions}) {
  const {decryptedVariantFile} = useDecryptVariant(variants, defaultVariant, contentType);
  if (!decryptedVariantFile) return null;

  return (
    <div>
      <DecryptedVariant decryptedVariantFile={decryptedVariantFile}/>
    </div>
  );
}

Attachment.propTypes = {
  contentType: PropTypes.string.isRequired,
  defaultVariant: PropTypes.oneOf(['auto', 'original']).isRequired,
  imageOptions: PropTypes.shape({
    height: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
    width: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
  }).isRequired,
  modal: PropTypes.bool.isRequired,
  variants: PropTypes.object.isRequired,
};
