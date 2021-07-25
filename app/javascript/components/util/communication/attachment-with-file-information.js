import {humanReadableBytes} from '../../../utils/numbers/human-readable-bytes';
import Attachment from './attachment';
import PropTypes from 'prop-types';
import mergeStyles from '../../../lib/styles/merge-styles';

export default function AttachmentWithFileInformation({file, informationClassName}) {
  return (
    <>
      <Attachment file={file}/>

      <div className={mergeStyles('mt-1 text-center', informationClassName)}>
        {file.name} - {humanReadableBytes(file.size)}
      </div>
    </>
  );
}

AttachmentWithFileInformation.propTypes = {
  file: PropTypes.object.isRequired,
  informationClassName: PropTypes.string,
};
