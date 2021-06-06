import {addPostsToStore, fetchMorePostsFromIndex, standardPostsStore} from './standard-posts/standard-posts-store';
import {useEffect} from 'react';
import {useState} from '@hookstate/core';
import InfiniteList from './util/infinite-list';
import StandardPost from './standard-posts/standard-post';

export default function StandardPostList({posts, peerId}) {
  const standardPostsStoreState = useState(standardPostsStore);

  useEffect(() => {
    standardPostsStore.batch(() => {
      addPostsToStore(posts);
      standardPostsStore.merge({peerId});
    });
  }, [posts, peerId]);

  return (
    <div className="w-full md:w-1/3 mx-auto">
      <div>
        <InfiniteList render={StandardPost} loadMore={fetchMorePostsFromIndex} storeItems={standardPostsStoreState.posts}/>
      </div>
    </div>
  );
}
