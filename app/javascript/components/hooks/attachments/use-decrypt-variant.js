import {DecryptedVariantFile} from '../../attachments/records/decrypted-variant-file';
import {useEffect, useState} from 'react';

export function useDecryptVariant(variants, defaultVariant, contentType) {
  const [state, setState] = useState({
    decryptedVariantFile: null,
  });

  useEffect(() => {
    const variant = variants[defaultVariant];
    setState({
      decryptedVariantFile: new DecryptedVariantFile(variant, contentType),
    });
  }, [variants, defaultVariant, contentType]);

  return {
    decryptedVariantFile: state.decryptedVariantFile,
  };
}
