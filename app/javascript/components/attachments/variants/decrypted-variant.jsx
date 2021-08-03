import ImageAttachment from '../attachments/image';
import PropTypes from 'prop-types';

export default function DecryptedVariant({decryptedVariantFile, imageOptions, fileName, download = false}) {
  const contentType = decryptedVariantFile.contentType;

  if (contentType.match(/^image\//)) {
    return (
      <ImageAttachment
        decryptedVariantFile={decryptedVariantFile} imageOptions={imageOptions}
        download={download} fileName={fileName}
      />
    );
  }

  return null;
}

DecryptedVariant.propTypes = {
  decryptedVariantFile: PropTypes.object.isRequired,
  download: PropTypes.bool,
  fileName: PropTypes.string.isRequired,
  imageOptions: PropTypes.object.isRequired,
};
