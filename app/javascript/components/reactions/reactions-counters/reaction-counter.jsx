import {formatNumberSocialMedia} from '../../../utils/numbers/format-number-social-media';
import PropTypes from 'prop-types';
import SafeEmojiString from '../../util/communication/emojis/safe-emoji-string';

export default function ReactionCounter({reactionCounter, localReactionsStore}) {
  const {character, reactionsCount} = reactionCounter;

  let string = character.get();
  const reactionsCountNumber = reactionsCount.get();

  if (reactionsCountNumber > 1) {
    string += ` ${formatNumberSocialMedia(reactionsCountNumber)}`;
  }

  const {counterEmojiSize: emojiSize, counterTextStyle: textStyle} = localReactionsStore;

  return (
    <div>
      <SafeEmojiString string={string} size={emojiSize} textStyle={textStyle}/>
    </div>
  );
}

ReactionCounter.propTypes = {
  localReactionsStore: PropTypes.object.isRequired,
  reactionCounter: PropTypes.object.isRequired,
};
