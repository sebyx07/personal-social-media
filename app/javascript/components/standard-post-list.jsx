import InfiniteList from './util/infinite-list';
import StandardPost from './standard-posts/standard-post';
import useInfiniteResource from './util/infinite-list/use-infinite-resource';

export default function StandardPostList({peerId}) {
  const query = {peerId, post_type: 'standard'};
  const infiniteResource = useInfiniteResource(query, {baseUrl: '/posts', query, resourcesRoot: 'posts'});

  return (
    <InfiniteList
      render={StandardPost}
      infiniteResource={infiniteResource}
      renderInitialLoading={<div>Loading posts...</div>}
      noResources={<div>No posts found</div>}
    />
  );
}
