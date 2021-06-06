import {axios} from '../../utils/axios';
import {createState} from '@hookstate/core';
import qs from 'qs';

export const standardPostsStore = createState({
  peerId: null,
  posts: [],
});

export function addPostsToStore(posts) {
  standardPostsStore.posts.merge(posts);
}

export function fetchMorePostsFromIndex(startIndex) {
  const post = standardPostsStore.posts[startIndex - 1];
  const queryString = qs.stringify({
    pagination: {from: post.id.get()},
    peer_id: standardPostsStore.peerId.get(),
    post_type: 'standard',
  });

  axios.get(`/posts?${queryString}`).then(({data: {posts}}) => {
    addPostsToStore(posts);
  });
}
