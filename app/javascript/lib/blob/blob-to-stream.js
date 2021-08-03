import {blobToBuffer} from './blob-to-buffer';

const {Readable} = require('stream-browserify');

export async function blobToStream(blob) {
  const rs = new Readable();
  rs._read = function() {};

  blobToBuffer(blob, (e, buffer) => {
    if (e) {
      rs.emit('error', e);
      rs.push(null);
    }
    rs.push(buffer);
    rs.push(null);
  });

  return rs;
}
