import {blobToStream} from '../blob/blob-to-stream';
import StreamToBlob from '../blob/stream-to-blob';

const {pipeline} = require('stream-browserify');
const algorithm = 'aes-256-cbc';
const {
  createDecipheriv, Buffer,
} = require('browser-crypto');

export function decryptBlob(blob, key, iv) {
  return new Promise(async (resolve) => {
    key = Buffer.from(key);
    iv = Buffer.from(iv);

    const decipher = createDecipheriv(algorithm, key, iv);
    const input = await blobToStream(blob);
    const output = new StreamToBlob();

    pipeline(input, decipher, output, (err) => {
      if (err) throw err;
      resolve(output.toBlob());
    });
  });
}
