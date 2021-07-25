import prettyBytes from 'pretty-bytes';

export function humanReadableBytes(bytes) {
  return prettyBytes(bytes);
}
