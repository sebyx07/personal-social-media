import {getHookstateProperties} from '../../lib/hookstate/get-properties';
import CommentStandardContent from './content-standard';
import RemotePeerAvatar from '../peers/avatars/remote-avatar';

export default function Comment({data: comment}) {
  const {commentType} = getHookstateProperties(comment, 'commentType', 'peer');
  let ContentTag;
  switch (commentType) {
    case 'standard':
      ContentTag = CommentStandardContent;
  }

  return (
    <div className="flex py-1">
      <div>
        <RemotePeerAvatar peer={comment.peer} imageClassName="h-6 w-6"/>
      </div>
      <div>
        <ContentTag comment={comment}/>
      </div>
    </div>
  );
}
