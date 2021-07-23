import {getHookstateProperties} from '../../lib/hookstate/get-properties';
import {truncateString} from '../../lib/string/truncate-string';
import {useState} from '@hookstate/core';

const maxUnexpandedMessageSize = 50;
export default function CommentStandardContent({comment}) {
  const state = useState({isExpanded: false});

  const {content: {message}} = getHookstateProperties(comment, 'content');
  const {isExpanded} = getHookstateProperties(state, 'isExpanded');
  const renderedContent = isExpanded ? message: truncateString(message, maxUnexpandedMessageSize);
  const showExpand = message.length > maxUnexpandedMessageSize;

  function toggleExpand(e) {
    e.preventDefault();
    state.merge({isExpanded: !isExpanded});
  }

  return (
    <div>
      {renderedContent}

      {
        showExpand && <a href="#" className="pl-1 text-white text-right cursor-pointer" onClick={toggleExpand}>
          Expand
        </a>
      }
    </div>
  );
}
