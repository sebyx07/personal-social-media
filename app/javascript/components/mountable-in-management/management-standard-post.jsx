import {transformKeys} from '../../lib/object/transformKeys';
import {useState} from '@hookstate/core';
import StandardPost from '../standard-posts/standard-post';

export default function MountableManagementStandardPost({post: rawPost}) {
  const post = useState(transformKeys(rawPost));

  return (
    <div className="p-2 bg-white">
      <StandardPost data={post}/>
    </div>
  );
}
