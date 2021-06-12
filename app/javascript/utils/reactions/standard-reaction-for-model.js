import {axios} from '../axios';

export function standardReactionForModelCreate(url, emoji) {
  return axios.post(url + '/reactions', {reaction: {character: emoji}});
}

export function standardReactionForModelDestroy(url, emoji) {
  return axios.delete(url + '/reactions', {data: {reaction: {character: emoji}}});
}
