import {useState} from '@hookstate/core';
import StandardPost from '../standard-posts/standard-post';
import transformObjectKeys from 'transform-object-keys';

export default function MountableManagementStandardPost({post: rawPost}) {
  const post = useState(transformObjectKeys(rawPost, {deep: true}));

  return (
    <div className="p-2 bg-white">
      <StandardPost data={post}/>
    </div>
  );
}
