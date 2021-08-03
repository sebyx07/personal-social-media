import {downloadBlob} from '../../../lib/blob/download-blob';
import {useEffect, useState} from 'react';
import DownloadButtonAttachment from './download-button';
import imagePlaceholder from '../../../images/placeholders/image-placeholder.svg';

export default function ImageAttachment({decryptedVariantFile, imageOptions = {}, download, fileName}) {
  const [state, setState] = useState({
    decryptedImageBlobUrl: null,
  });

  useEffect(() => {
    let url;
    decryptedVariantFile.simpleSerialFileDecrypt().then((blob) => {
      url = URL.createObjectURL(blob);
      setState((state) => {
        return {
          ...state,
          decryptedImageBlobUrl: url,
        };
      });
    });

    return () => URL.createObjectURL(url);
  }, [decryptedVariantFile]);

  const {decryptedImageBlobUrl} = state;

  function downloadAttachment() {
    downloadBlob({
      blobUrl: decryptedImageBlobUrl,
      fileName,
    });
  }

  const imageUrl = decryptedImageBlobUrl || imagePlaceholder;

  return (
    <>
      {
        download && decryptedImageBlobUrl && <DownloadButtonAttachment onClick={downloadAttachment}/>
      }
      <img src={imageUrl} {...imageOptions} className="!h-full w-full"/>
    </>
  );
}
