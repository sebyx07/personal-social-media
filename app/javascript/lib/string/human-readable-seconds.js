const prettySeconds = require('pretty-seconds/dist/pretty-seconds');

export function humanReadableSeconds(seconds) {
  return prettySeconds(seconds);
}