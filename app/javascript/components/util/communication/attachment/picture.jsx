export default function AttachmentPicture({file}) {
  const objectUrj = URL.createObjectURL(file);

  return (
    <div>
      <img src={objectUrj} alt="attachments picture"/>
    </div>
  );
}
