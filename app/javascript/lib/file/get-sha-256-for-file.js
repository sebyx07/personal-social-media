import {Hash as Hash256} from 'fast-sha256';
import {handleFileInChunks} from './handle-file-in-chunks';
import {ui8arrayToHex} from '../string/ui8array-to-hex';

export async function getSha256ForFile(file, cbProgress) {
  const hashSha256 = new Hash256();

  await handleFileInChunks(file, (uInt8ArrayChunk) => {
    return hashSha256.update(uInt8ArrayChunk);
  }, cbProgress);

  return ui8arrayToHex(hashSha256.digest());
}
