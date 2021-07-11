import InfiniteList from './util/infinite-list';
import StandardPost from './standard-posts/standard-post';
import useInfiniteResource from './util/infinite-list/use-infinite-resource';
import {StrictMode} from 'react';

export default function StandardPostList({peerId, showFromFeedOnly}) {
  const query = {peerId, post_type: 'standard', showFromFeedOnly};
  const infiniteResource = useInfiniteResource(query, {baseUrl: '/posts', query, resourcesRoot: 'posts'});

  return (
    <StrictMode>
      <InfiniteList
        render={StandardPost}
        infiniteResource={infiniteResource}
        renderInitialLoading={<div>Loading posts...</div>}
        loading={<div>Loading more posts...</div>}
        noResources={<div>No posts found</div>}
      />
    </StrictMode>
  );
}
