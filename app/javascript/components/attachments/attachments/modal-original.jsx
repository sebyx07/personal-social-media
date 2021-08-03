import {useDecryptVariant} from '../../hooks/attachments/use-decrypt-variant';
import DecryptedVariant from '../variants/decrypted-variant';

export default function AttachmentModalOriginal({variants, contentType, imageOptions, fileName}) {
  const {decryptedVariantFile} = useDecryptVariant(variants, 'original', contentType);
  if (!decryptedVariantFile) return null;

  return (
    <div className="p-6">
      <DecryptedVariant decryptedVariantFile={decryptedVariantFile} imageOptions={imageOptions} download={true} fileName={fileName}/>
    </div>
  );
}