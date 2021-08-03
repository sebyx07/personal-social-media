import {downloadBlob} from '../../../lib/blob/download-blob';
import {useEffect, useState} from 'react';
import DownloadButtonAttachment from './download-button';

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
  if (!decryptedImageBlobUrl) return null;

  function downloadAttachment() {
    downloadBlob({
      blobUrl: decryptedImageBlobUrl,
      fileName,
    });
  }

  return (
    <>
      {
        download && <DownloadButtonAttachment onClick={downloadAttachment}/>
      }
      <img src={decryptedImageBlobUrl} {...imageOptions} className="!h-full w-full"/>
    </>
  );
}
