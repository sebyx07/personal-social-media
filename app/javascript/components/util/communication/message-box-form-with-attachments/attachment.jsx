import Attachment from '../attachment';
import PropTypes from 'prop-types';


export default function MessageBoxAttachment({attachmentRecord}) {
  const {file} = attachmentRecord;
  return (
    <div className="h-20 w-20 p-1">
      <Attachment file={file}/>
    </div>
  );
}

MessageBoxAttachment.propTypes = {
  attachmentRecord: PropTypes.object.isRequired,
};

export function buildAttachmentRecord(file) {
  const key = `${file.name}-${file.size}-${file.lastModified}`;

  return {
    file,
    key,
  };
}
