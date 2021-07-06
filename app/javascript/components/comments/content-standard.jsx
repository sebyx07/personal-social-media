import {getHookstateProperties} from '../../lib/hookstate/get-properties';

export default function CommentStandardContent({comment}) {
  const {content} = getHookstateProperties(comment, 'content');

  return (
    <div>
      {content.message}
    </div>
  );
}
