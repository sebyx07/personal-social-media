import AttachmentPicture from './attachment/picture';

export default function Attachment({file}) {
  let attachment;
  if (file.type.match('image')) {
    attachment = (<AttachmentPicture file={file}/>);
  }

  return (
    <div>
      {attachment}
    </div>
  );
}
