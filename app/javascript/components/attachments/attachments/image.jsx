import {useEffect, useState} from 'react';

export default function ImageAttachment({decryptedVariantFile}) {
  const [state, setState] = useState({
    decryptedImageBlobUrl: null,
  });
  
  useEffect(() => {
    decryptedVariantFile.simpleSerialFileDecrypt().then((blob) => {
      const url = URL.createObjectURL(blob);
      setState((state) => {
        return {
          ...state,
          decryptedImageBlobUrl: url,
        };
      });
    });
  }, [decryptedVariantFile]);

  return (
    <div>
      {state.decryptedImageBlobUrl && <div>
        <img src={state.decryptedImageBlobUrl} alt=""/>
      </div>}
    </div>
  );
}
