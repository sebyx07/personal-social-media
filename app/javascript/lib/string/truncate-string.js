import {isEmpty} from 'lodash';

export function truncateString(string, size) {
  if (isEmpty(string)) return string;
  if (string.length <= size) return string;
  return string.substring(0, size) + '...';
}
