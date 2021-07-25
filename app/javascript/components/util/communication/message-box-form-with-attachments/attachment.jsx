import AttachmentWithFileInformation from '../attachment-with-file-information';
import PropTypes from 'prop-types';

export default function MessageBoxAttachment({attachmentRecord}) {
  const {file} = attachmentRecord;
  return (
    <div className="flex flex-col justify-between h-full">
      <AttachmentWithFileInformation file={file} informationClassName="text-xs"/>
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
