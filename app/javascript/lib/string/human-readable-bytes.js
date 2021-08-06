const prettyBytes = require('pretty-bytes');

export function humanReadableBytes(bytes) {
  return prettyBytes(bytes);
}