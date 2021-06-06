import {addPostsToStore, standardPostsStore} from './standard-posts/standard-posts-store';
import {useEffect} from 'react';
import {useState} from '@hookstate/core';
import StandardPost from './standard-posts/standard-post';

export default function StandardPostList({posts}) {
  const standardPostsStoreState = useState(standardPostsStore);

  useEffect(() => {
    addPostsToStore(posts);
  }, [posts]);

  return (
    <div className="w-full md:w-1/3 mx-auto">
      <div>
        {
          standardPostsStoreState.posts.map((p) => {
            return <StandardPost post={p} key={p.id.get()}/>;
          })
        }
      </div>
    </div>
  );
}
