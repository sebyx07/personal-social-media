import {compact, join} from 'lodash';

export default function mergeStyles(...styles) {
  return join(compact(styles), ' ');
}
