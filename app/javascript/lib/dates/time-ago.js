import {format} from 'date-fns';
import TimeAgo from 'javascript-time-ago';

import en from 'javascript-time-ago/locale/en';
const sixHoursAgo = getHoursAgo(6);
const yesterday = getDaysAgo(1);
const twoDaysAgo = getDaysAgo(2);
const oneWeekAgo = getDaysAgo(7);
const sixMonthsAgo = getDaysAgo(180);

TimeAgo.addDefaultLocale(en);
const timeAgo = new TimeAgo('en-US');

export function timeAgoInWords(date) {
  if (typeof date === 'string') {
    date = Date.parse(date);
  }

  if (sixMonthsAgo > date) {
    return format(date, 'LLLL dd yyyy HH:mm');
  }

  if (oneWeekAgo > date) {
    return format(date, 'LLLL dd HH:mm');
  }

  if (twoDaysAgo > date) {
    return format(date, 'EEEE HH:mm');
  }

  if (yesterday > date) {
    return 'yesterday ' + format(date, 'HH:mm');
  }

  if (sixHoursAgo > date) {
    return 'Today ' + format(date, 'HH:mm');
  }

  return timeAgo.format(date);
}

function getDaysAgo(days) {
  const date = new Date();
  date.setDate(date.getDate() - days);

  return date.getTime();
}

function getHoursAgo(hours) {
  const date = new Date();
  date.setHours(date.getHours() - hours);

  return date.getTime();
}
