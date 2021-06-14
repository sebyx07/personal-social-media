import {timeAgoInWords} from '../../../lib/dates/time-ago';
import DefaultPeerAvatar from '../../peers/avatars/default-avatar';
import SafeEmojiString from '../../util/communication/emojis/safe-emoji-string';

export default function ReactionFromHistory({data: reaction}) {
  const {peer, createdAt, character} = reaction;

  return (
    <div className="my-2 flex justify-between items-center">
      <DefaultPeerAvatar peer={peer}>
        <div>
          {timeAgoInWords(createdAt.get())}
        </div>
      </DefaultPeerAvatar>

      <div>
        <SafeEmojiString string={character.get()} size={35}/>
      </div>
    </div>
  );
}
