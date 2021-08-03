import {DecryptedVariantFile} from '../../attachments/records/decrypted-variant-file';
import {useEffect, useState} from 'react';

export function useDecryptVariant(variants, defaultVariant, contentType) {
  const [state, setState] = useState({
    decryptedVariantFile: null,
  });

  useEffect(() => {
    let variant = variants[defaultVariant];
    if (!variant) variant = variants['original'];

    setState({
      decryptedVariantFile: new DecryptedVariantFile(variant, contentType),
    });
  }, [variants, defaultVariant, contentType]);

  return {
    decryptedVariantFile: state.decryptedVariantFile,
  };
}
