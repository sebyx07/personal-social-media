import {transformKeys} from '../../lib/object/transformKeys';
import Attachment from '../attachments/attachment';
const attachmentImageOptions = {
  height: '10rem',
  width: '10rem',
};

export default function MountablePsmFile({data}) {
  const {contentType, variants} = transformKeys(data);

  return (
    <div>
      <Attachment
        contentType={contentType} variants={variants} defaultVariant="original" imageOptions={attachmentImageOptions} modal
      />
    </div>
  );
}
