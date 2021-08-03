import {transformKeys} from '../../lib/object/transformKeys';
import Attachment from '../attachments/attachment';
import mergeStyles from '../../lib/styles/merge-styles';
const attachmentImageOptions = {
  className: 'object-cover',
  style: {maxWidth: 'none'},
};

export default function MountablePsmFile({data, className}) {
  const {contentType, variants, name: fileName} = transformKeys(data);

  return (
    <div className={mergeStyles(className, 'relative')}>
      <Attachment
        contentType={contentType} fileName={fileName}
        variants={variants} defaultVariant="original" imageOptions={attachmentImageOptions}
        modal
      />
    </div>
  );
}
