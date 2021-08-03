import ImageAttachment from '../attachments/image';

export default function DecryptedVariant({decryptedVariantFile}) {
  const contentType = decryptedVariantFile.contentType;

  if (contentType.match(/^image\//)) {
    return (
      <ImageAttachment decryptedVariantFile={decryptedVariantFile}/>
    );
  }

  return null;
}
