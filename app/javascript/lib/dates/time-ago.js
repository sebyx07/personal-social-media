import TimeAgo from 'javascript-time-ago';

import en from 'javascript-time-ago/locale/en';

TimeAgo.addDefaultLocale(en);
const timeAgo = new TimeAgo('en-US');

export function timeAgoInWords(date) {
  if (typeof date === 'string') {
    date = Date.parse(date);
  }

  return timeAgo.format(date);
}
