import {formatNumberSocialMedia} from '../../../utils/numbers/format-number-social-media';
import PropTypes from 'prop-types';
import SafeEmojiString from '../../util/communication/emojis/safe-emoji-string';

export default function ReactionCounter({reactionCounter}) {
  const {character, reactionsCount} = reactionCounter;

  let string = character.get();
  const reactionsCountNumber = reactionsCount.get();

  if (reactionsCountNumber > 1) {
    string += ` ${formatNumberSocialMedia(reactionsCountNumber)}`;
  }

  return (
    <div>
      <SafeEmojiString string={string} size={27} textStyle={{fontSize: '1rem', marginLeft: '2px'}}/>
    </div>
  );
}

ReactionCounter.propTypes = {
  reactionCounter: PropTypes.object.isRequired,
};
