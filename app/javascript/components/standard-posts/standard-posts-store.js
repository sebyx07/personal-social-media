import {createState} from '@hookstate/core';

export const standardPostsStore = createState({
  posts: [],
});

export function addPostsToStore(posts) {
  standardPostsStore.posts.merge(posts);
}
